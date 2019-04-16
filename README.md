# Redmine Status Report plugin

Plugin is intended to show status statistics for the issue.

It shows statistics in two forms: brief statistics with totals per each status, and chronological transition between statuses showing how much status took.

Example of brief statistics:

| Status | Lasted for |
| ------ | ---------- |
| New |	6 days |
| In Progress |	29 days |
| Resolved | about 21 hours |

Example of all chronological transitions:

| Status      | Occured on        | Lasted for           |
|-------------|-------------------|----------------------|
| New         | 06 Mar 2019 18:17 | about 12 hours       |
| In Progress | 07 Mar 2019 06:02 | less than 5 seconds  |
| New         | 07 Mar 2019 06:02 | about 6 hours        |
| In Progress | 07 Mar 2019 12:20 | less than 5 seconds  |
| New         | 07 Mar 2019 12:20 | 6 days               |
| In Progress | 13 Mar 2019 05:42 | 4 days               |
| New         | 17 Mar 2019 17:24 | 16 minutes           |
| In Progress | 17 Mar 2019 17:40 | about 1 hour         |
| New         | 17 Mar 2019 18:45 | half a minute        |
| In Progress | 17 Mar 2019 18:45 | less than 20 seconds |
| Resolved    | 17 Mar 2019 18:45 | less than 5 seconds  |
| In Progress | 17 Mar 2019 18:45 | 25 days              |
| Resolved    | 11 Apr 2019 11:11 | about 21 hours       |
| In Progress | 12 Apr 2019 07:56 | 7 minutes            |
| Resolved    | 12 Apr 2019 08:04 | Current              |

Plugin works well with PurpleMine theme.
