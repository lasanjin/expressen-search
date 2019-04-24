search() {
    local fromdate=$1 && shift
    local todate=$1 && shift
    local args=($@)

    if [ -z $1 ]; then
        echo -e "Invalid input"
        return 0
    elif ! is_valid $fromdate || ! is_valid $todate; then
        echo "Invalid date"
        return 0
    fi

    declare arguments
    for arg in "$args"; do
        arguments+="match(\"$arg\"; \"i\") and "
    done

    local conditions=${arguments:0:-5}
    local url=$(expressen_url)

    expressen_data
    if [ -z "$data" ]; then
        echo -e "\rNo data \033[K"
        return 0
    else
        echo -e "\n"
    fi

    #format data
    declare -A newdata
    declare formated
    local length=${#data[@]}
    for ((i = 0; i < $length; i += 2)); do

        local date=${data[i]}
        local food=${data[$((i + 1))]}

        formated=$(date --date "$date" +'%Y-%m-%d')
        newdata+=([$formated]=$food)
    done

    #sort data
    for key in "${!newdata[@]}"; do
        echo $key ' - ' ${newdata[$key]}
    done | sort -k1

    echo -e "\n${#newdata[@]} matches"
    echo ""
}

expressen_url() {
    local api='v1/mealprovidingunits/3d519481-1667-4cad-d2a3-08d558129279/dishoccurrences?startDate='$fromdate'&endDate='$todate''
    local url='http://carbonateapiprod.azurewebsites.net/api/'$api''
    echo $url
}

expressen_data() {
    echo -n "Fetching data..."
    local rawdata=$(curl -s $url |
        jq -r ".[] | select(.dish.dishName | $conditions) | .startDate, .dish.dishName")

    IFS=$'\n'
    read -r -a data -d '' <<<"$rawdata"
    unset IFS
}

is_valid() {
    [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$1" >/dev/null
}

search $@
