# ==============================================================================
# PLATFORM ENGINEERING & SYSTEM TRIAGE ALIASES
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. RESOURCE INSPECTION & SYSTEM STATE
# ------------------------------------------------------------------------------
# One-liner snapshot of kernel, OS release, uptime, and system load
alias sysinfo='echo "=== KERNEL & OS ===" && uname -a && cat /etc/os-release | grep PRETTY_NAME && echo "=== UPTIME & LOAD ===" && uptime'

# Disk usage restricted to real block devices (filters out loop, tmpfs, squashfs, overlay)
alias dfh='df -h -T -x tmpfs -x devtmpfs -x squashfs -x overlay'

# Memory usage in human-readable SI units
alias freeh='free -h --si'

# Top 10 resource-intensive processes (quick CPU/RAM triage)
alias topcpu='ps aux --sort=-%cpu | head -n 11'
alias topmem='ps aux --sort=-%mem | head -n 11'

# ------------------------------------------------------------------------------
# 2. NETWORK TRIAGE & PORT VISIBILITY
# ------------------------------------------------------------------------------
# Active listening ports with associated PID and process names
alias listen='sudo ss -tulpn'

# Socket and connection statistics breakdown
alias conns='sudo ss -s'

# Quick public IP and egress verification
alias myip='curl -s https://ifconfig.me && echo'

# Clean network interfaces and IP addresses overview
alias ipbrief='ip -br -c a'

# Quick TCP port connectivity test (Usage: checkport <ip> <port>)
alias checkport='timeout 2 bash -c "</dev/tcp/\$1/\$2" && echo "PORT OPEN" || echo "PORT CLOSED/BLOCKED"'

# Active DNS servers check
alias dnscheck='cat /etc/resolv.conf | grep nameserver'

# ------------------------------------------------------------------------------
# 3. KUBERNETES TRIAGE & DIAGNOSTICS
# ------------------------------------------------------------------------------
# Core kubectl shorthand
alias k='kubectl'

# Cluster-wide resource overview across all namespaces
alias kgp='kubectl get pods -A'
alias kgn='kubectl get nodes -o wide'
alias kgs='kubectl get svc -A'

# Instantly filter non-healthy pods (CrashLoopBackOff, Pending, ImagePullBackOff, Error)
alias kbad='kubectl get pods -A --field-selector status.phase!=Running,status.phase!=Succeeded'

# Top resource consumers (Node and Pod level)
alias ktopn='kubectl top nodes'
alias ktopp='kubectl top pods -A --sort-by=cpu'

# Recent cluster events sorted by timestamp (essential for root cause analysis)
alias kevents='kubectl get events -A --sort-by=".metadata.creationTimestamp" | tail -n 30'

# Quick pod manifest export to YAML for deep-dive analysis
alias kpod2yaml='kubectl get pod -o yaml'

# Quick live log streaming for target pod (Usage: klogs <pod-name>)
alias klogs='kubectl logs --tail=100 -f'

# Pod restart counters and status overview
alias krestart='kubectl get pods -A --sort-by=".status.containerStatuses[0].restartCount" | tail -n 20'

# Service and Endpoints binding check (verify if pods are backing the service)
alias kep='kubectl get endpoints -A'

# ------------------------------------------------------------------------------
# 4. CONTAINER INFRASTRUCTURE (DOCKER / CONTAINERD)
# ------------------------------------------------------------------------------
# Clean, human-readable docker ps output without noise
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'

# Non-streaming container resource stats
alias dstats='docker stats --no-stream'

# System cleanup: prune unused containers, networks, and images
alias dclean='docker system prune -f --volumes'

# ------------------------------------------------------------------------------
# 5. SYSLOG, JOURNAL & KERNEL ERROR TRIAGE
# ------------------------------------------------------------------------------
# High-severity system log entries from the past hour
alias errlogs='journalctl -p err..emerg --since "1 hour ago"'

# Stream high-priority logs in real-time
alias tailerr='sudo journalctl -xfp err..emerg'

# Failed systemd units inspection
alias failedsys='systemctl --failed'

# Check dmesg for OOM killer invocations (case-insensitive)
alias oom='sudo dmesg -T | grep -iE "oom[-_]killer|killed process"'

# Full kernel panic, segfault, and OOM triage in one shot
alias kernerr='sudo dmesg -T --level=err,crit,alert,emerg | grep -iE "oom|panic|segfault|kernel bug"'

# Stream kernel logs in real-time filtering for memory/OOM issues
alias oomwatch='sudo dmesg -Tw | grep --line-buffered -iE "oom|memory"'

# ------------------------------------------------------------------------------
# 6. LIVE INTERVIEW & TRIAGE ACCELERATORS
# ------------------------------------------------------------------------------
# Top 10 largest directories on root (quick disk usage inspection)
alias dudepth='sudo du -hx --max-depth=1 / 2>/dev/null | sort -rh | head -n 11'

# Find open files held by processes but deleted from disk (space leak root cause)
alias dfdeleted='sudo lsof +L1 2>/dev/null | grep -i deleted'

# Recently modified files in /var/log (what changed in the last 10 minutes?)
alias logfresh='sudo find /var/log -type f -mmin -10'

# ------------------------------------------------------------------------------
# 7. PRODUCTIVITY & SAFETY NET
# ------------------------------------------------------------------------------
# Print PATH environment variable line-by-line for readability
alias path='echo $PATH | tr ":" "\n"'

# Interactive prompt overrides to prevent accidental overwrites during triage
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Reload shell configuration on the fly
alias reload='source ~/.bashrc && echo "Shell profile reloaded successfully."'
