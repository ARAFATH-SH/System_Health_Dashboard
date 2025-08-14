It is a lightweight Bash script designed to provide real-time monitoring
of essential system performance metrics directly from the terminal. The tool displays CPU usage per core,
memory consumption, disk usage, network statistics, and logged-in user information. It also highlights the top
CPU- and memory-consuming processes and presents graphical progress bars for visual clarity. All statistics are
logged into a CSV file for historical analysis. This project offers a resource-efficient solution for system
administrators, developers, and Linux users to track system health without relying on heavy GUI-based tools.

# Core Components
  cpu_usage() – Shows CPU usage per core.
  memory_usage() – Displays RAM usage.
  disk_usage() – Lists storage usage.
  top_processes() – Lists top CPU and memory consuming processes.
  network_stats() – Shows IP addresses and data transfer.
  user_activity() – Displays logged-in users.
  draw_bar() – Draws resource usage bars.
  log_stats() – Saves metrics to CSV

# Future Enhancements
  Add alert notifications on mail.
  Support customizable refresh intervals.
