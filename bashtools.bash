
function waitfor {
	while pgrep $1 > /dev/null; do
		echo -n "."
		sleep 1
	done
    echo
    ${@:2}
}

function relentlessly {
    false
    until [ "$?" = "0" ]
    do
        $@
    done
}

function source_filter {
    grep -v /\\. | grep -v .pyc | grep -v '~$'
}

function latest_change {
    if [ -f $1 ]; then
        stat -c %Y $1
    elif [ -d $1 ]; then
        for fname in $(find $(realpath $1) -type f | grep -v /\\.); do
            latest_change $fname
        done | sort -n | tail -n 1
    fi
}

function trigger {
    if [ ! -e $1 ]; then
        echo "no such file $1"
        return 1
    fi

    clear
    date
    ${@:2} 2>&1 | head -n 20
    if [ "$?" -eq "0" ]; then echo "---- :-) "; else echo "---- :-( "; fi
    LAST_MOD_TIME=$(latest_change $1)

    while true; do
        sleep 0.2
        CUR_MOD_TIME=$(latest_change $1)
        if [ $LAST_MOD_TIME -lt $CUR_MOD_TIME ] ; then
            clear
            date
            ${@:2} 2>&1 | head -n 20
            if [ "$?" -eq "0" ]; then echo "---- :-) "; else echo "---- :-( "; fi
            LAST_MOD_TIME=$(latest_change $1)
        fi
    done
}

function retrigger {
    if [ ! -e $1 ]; then
        echo "no such file $1"
        return 1
    fi

    clear
    date
    ${@:2} &
    PID=$!
    LAST_MOD_TIME=$(latest_change $1)

    while true; do
        sleep 0.2
        CUR_MOD_TIME=$(latest_change $1)
        if [ $LAST_MOD_TIME -lt $CUR_MOD_TIME ] ; then
            kill $PID 2> /dev/null
            wait $PID
            clear
            date
            ${@:2} &
            PID=$!
            LAST_MOD_TIME=$(latest_change $1)
        fi
    done
}

function make-add-path-func {
    func_name=$1
    dest_path=$2
    variable_name=$3

    if [ "$1" = "" -o "$2" = "" ];
    then
        echo "Error, missing parameter to make-add-path-func. Usage:"
        echo "make-add-path-func function name> <destination>"
        return 1
    fi

    eval '
    function '$func_name' {
        for x in $*
        do
            new_entry=$(realpath $x)
            full_flat=$(echo $new_entry | sed -e "s/\//_/g")
            mkdir -p '$dest_path'
            ln -sf $new_entry '$dest_path'/$full_flat
        done
    }'

    if [ "$3" != "" ];
    then
        for x in ${dest_path}/*;
        do
            eval ${variable_name}=\$${variable_name}:`realpath $x`
        done
        export ${variable_name}
    fi
}

