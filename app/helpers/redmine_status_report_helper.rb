class RedmineStatusReportHelper
  extend ActionView::Helpers::DateHelper

  def self.base_sql(issue_id)
    <<-SQL
select _t.*
     , s.name as status_name
     , unix_timestamp(till) - unix_timestamp(since) as transition_age_secs
from (
   select *
   from (
      select i.created_on as since, j.updated_on as till, old_value as status_id
      from journals j
             join journal_details d on d.journal_id = j.id
             join issues i on i.id = j.journalized_id
      where j.journalized_type = 'Issue'
        and j.journalized_id = #{issue_id}
        and d.prop_key = 'status_id'
      order by j.updated_on
      limit 1
    ) as _first

   union all

   select j.updated_on as since
        , min(if(jnd.id is not null, jn.updated_on, null)) as till
        , d.value as status_id
   from journals j
          join journal_details d on d.journal_id = j.id
          left join journals jn on jn.id != j.id and jn.updated_on >= j.updated_on and
                                   jn.journalized_type = j.journalized_type and
                                   jn.journalized_id = j.journalized_id
          left join journal_details jnd on jnd.journal_id = jn.id and jnd.prop_key = 'status_id'
   where j.journalized_type = 'Issue'
     and j.journalized_id = #{issue_id}
     and d.prop_key = 'status_id'
   group by j.id, j.updated_on, d.value
   order by since
  ) as _t
  join issue_statuses s on s.id = _t.status_id
    SQL
  end

  def self.load_all(issue)
    ActiveRecord::Base.connection.exec_query base_sql(issue.id)
  end

  def self.load_stats(issue)
    sql = <<-SQL
      select status_id, status_name, sum(transition_age_secs) as total_status_secs from (
        #{base_sql(issue.id)}
      ) as _t
      group by status_id, status_name
    SQL

    ActiveRecord::Base.connection.exec_query sql
  end

  def self.secs_to_duration_string(secs)
    if secs.nil?
      return nil
    end

    distance_of_time_in_words(0, secs, include_seconds: true)
  end
end