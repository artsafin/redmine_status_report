module RedmineStatusReport

  class Hooks < Redmine::Hook::ViewListener
    render_on :view_layouts_base_html_head, partial: 'issues_status_report/additional_assets'

    render_on(
        :view_issues_show_description_bottom,
        partial: 'issues_status_report/view_issues_show_description_bottom'
    )
  end

end