class RedmineStatusReportHelper
  extend ActionView::Helpers::DateHelper

  def self.base_sql(issue_id)
    <<-SQL
select _t.*
     , s.name as status_name
     , concat(u.firstname, ' ', u.lastname) as user_name
     , unix_timestamp(till) - unix_timestamp(since) as transition_age_secs
from (
   select *
   from (
      select
        i.created_on as since
        , i.author_id as user_id
        , j.updated_on as till
        , old_value as status_id
      from #{Journal.table_name} j
             join #{JournalDetail.table_name} d on d.journal_id = j.id
             join #{Issue.table_name} i on i.id = j.journalized_id
      where j.journalized_type = 'Issue'
        and j.journalized_id = #{issue_id}
        and d.prop_key = 'status_id'
      order by j.updated_on
      limit 1
    ) as _first

   union all

   select j.updated_on as since
        , j.user_id
        , min(if(jnd.id is not null, jn.updated_on, now())) as till
        , d.value as status_id
   from #{Journal.table_name} j
          join #{JournalDetail.table_name} d on d.journal_id = j.id
          left join #{Journal.table_name} jn on jn.id != j.id and jn.updated_on >= j.updated_on and
                                   jn.journalized_type = j.journalized_type and
                                   jn.journalized_id = j.journalized_id
          left join #{JournalDetail.table_name} jnd on jnd.journal_id = jn.id and jnd.prop_key = 'status_id'
   where j.journalized_type = 'Issue'
     and j.journalized_id = #{issue_id}
     and d.prop_key = 'status_id'
   group by j.id, j.user_id, j.updated_on, d.value
   order by since
  ) as _t
  join #{IssueStatus.table_name} s on s.id = _t.status_id
  left join #{User.table_name} u on u.id = _t.user_id
    SQL
  end

  def self.load_all(issue)
    res = ActiveRecord::Base.connection.exec_query base_sql(issue.id)

    total = res.reduce(0) { |sum, row| sum + row['transition_age_secs'].to_i }

    res.each_with_index do |row, idx|
      row['percent'] = (100 * row['transition_age_secs'].to_f / total).round(2)
      row['percent_running_total'] = idx == 0 ? 0 : (res[idx - 1]['percent'] + res[idx - 1]['percent_running_total']).round(2)
    end

    if issue.closed?
      last_rec = res[res.length - 1]

      last_rec['till'] = nil
      last_rec['transition_age_secs'] = nil
      last_rec['percent'] = 0
      last_rec['percent_running_total'] = 0
    end

    res
  end

  def self.load_stats(issue)
    sql = <<-SQL
      select status_id, status_name, sum(transition_age_secs) as total_status_secs from (
        #{base_sql(issue.id)}
      ) as _t
      group by status_id, status_name
    SQL

    res = ActiveRecord::Base.connection.exec_query sql

    total = res.reduce(0) { |sum, row| sum + row['total_status_secs'].to_i }

    res.map do |row|
      row['percent'] = (100 * row['total_status_secs'].to_f / total).round(2)
      row
    end
  end

  def self.secs_to_duration_string(secs)
    if secs.nil?
      return nil
    end

    distance_of_time_in_words(0, secs, include_seconds: true)
  end
end