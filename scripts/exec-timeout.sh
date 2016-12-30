# Spawn a child process:
cmd=$*
$cmd & pid=$!
# in the background, sleep for 10 secs then kill that process
(sleep 10 && kill -9 $pid) & waiter=$!
# wait on our worker process and return the exitcode
exitcode=$(wait $pid && echo $?)
# kill the waiter subshell, if it still runs
kill -9 $waiter 2>/dev/null
# 0 if we killed the waiter, cause that means the process finished before the waiter
finished_gracefully=$?
