search() {
    local url=$(expressen_url "2000-01-01")

    declare arguments
    for arg in "$@"; do
        arguments+="match(\"$arg\"; \"i\") and "
    done

    echo -n "Fetching data..."

    conditions=${arguments:0:-5}
    local data=$(curl -s $url |
        jq -r ".[] | select(.dish.dishName | $conditions) | .startDate, .dish.dishName")

    IFS=$'\n'
    read -r -a arr -d '' <<<"$data"
    unset IFS

    if [ -z "$data" ]; then
        echo -e "\rNo data \033[K"
        return 0
    fi

    echo -e "\n"

    length=${#arr[@]}
    declare -A newarr
    for ((i = 0; i < $length; i += 2)); do
        local date=${arr[i]}
        local food=${arr[$((i + 1))]}
        newdate=$(date --date "$date" +'%Y-%m-%d')
        newarr+=([$newdate]=$food)
    done

    for key in "${!newarr[@]}"; do
        echo $key ' - ' ${newarr[$key]}
    done | sort -k1

    echo -e "\n${#newarr[@]} matches"
    echo ""
}

expressen_url() {
    local fromdate=$1
    local todate=$(date +'%Y-%m-%d')
    if [ ! -z $2 ]; then
        todate=$2
    fi
    local api='v1/mealprovidingunits/3d519481-1667-4cad-d2a3-08d558129279/dishoccurrences?startDate='$fromdate'&endDate='$todate''
    local url='http://carbonateapiprod.azurewebsites.net/api/'$api''
    echo $url
}

search $@
