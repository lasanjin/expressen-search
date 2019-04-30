#!/bin/bash

search() {
    local fromdate=$1 && shift
    local todate=$1 && shift
    local args=$@

    #validate input
    if [ -z $1 ]; then
        echo -e "Invalid input"
        return 0
    elif ! is_valid $fromdate || ! is_valid $todate; then
        echo "Invalid date"
        return 0
    fi

    build_params
    local url=$(expressen_url)

    #get data
    expressen_data
    if is_empty $data; then
        echo -e "\rNo data \033[K"
        return 0
    else
        echo -e "\n"
    fi

    #count food & map formated dates to food in order to sort by date
    declare local count
    declare -A local newdata
    format

    #sort data
    IFS=';'
    read -r -a sorted -d '' <<<"$(
        for key in "${!newdata[@]}"; do
            printf "%s\n" "$key: ${newdata[$key]}"
        done | sort -k1
    )"

    #print data
    print

    unset IFS
    echo -e "\n\n$count matches"
    echo ""
}

build_params() {
    declare local arguments
    for arg in $args; do
        if [ "$arg" == "." ]; then
            arguments+="match(\".\"; \"i\") and "
            break
        fi

        arguments+="match(\"\\\b$arg\\\b\"; \"i\") and "
    done

    param=${arguments:0:-5}
}

expressen_url() {
    local sDate='?startDate='$fromdate''
    local eDate='&endDate='$todate''
    local api='v1/mealprovidingunits/3d519481-1667-4cad-d2a3-08d558129279/dishoccurrences'$sDate''$eDate''
    local url='http://carbonateapiprod.azurewebsites.net/api/'$api''
    echo $url
}

expressen_data() {
    echo -n "Fetching data..."
    local rawdata=$(curl -s $url |
        jq -r ".[] | select(.dish.dishName | $param) | .startDate, .dish.dishName")

    IFS=$'\n'
    read -r -a data -d '' <<<"$rawdata"
    unset IFS
}

format() {
    local -r dateformat='+%Y-%m-%d'
    local length=${#data[@]}
    for ((i = 0; i < $length; i += 2)); do

        local date=${data[i]}
        local food=${data[$((i + 1))]}
        local formated=$(date --date "$date" $dateformat)

        if is_food $food; then
            local prev=${newdata[$formated]}

            if is_empty $prev; then
                newdata+=([$formated]="$food;")
            else
                newdata[$formated]="$prev$food;"
            fi

            ((count++))
        fi
    done
}

print() {
    local length=${#sorted[@]}
    for ((i = 0; i < $length; i += 1)); do

        local current=${sorted[i]}

        if contains_digits "$current"; then
            echo -n $current
        elif ! is_empty $current && ! is_newline $current; then
            echo -en "\n\t    $current"
        fi
    done
}

is_valid() {
    [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$1" >/dev/null
}

is_food() {
    [[ "$1" != *"visning"* ]]
}

is_empty() {
    [ -z $1 ]
}

contains_digits() {
    [[ "$1" =~ [0-9] ]]
}

is_newline() {
    [[ $1 == *$'\n'* ]]
}

search $@
