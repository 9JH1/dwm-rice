echo "$( \
	uptime |\
	tr ',' '\n' |\
	tr ':' '\n' |\
	tail -n 3 |\
	head -n 1 |\
	tr -d '\n' \
	)"
