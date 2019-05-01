## Description
Gets, maps, sorts & outputs historic data from expressen [api](https://chalmerskonferens.se/en/api/).

<img src="expsearch-GIF.gif" width="640">

## Get jq
Alt 1
1. Install jq
```
$ sudo apt-get install jq
```

Alt 2
1. Download jq
```
$ wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
```
2. Make script executable
```
$ sudo chmod +x ./jq-linux64.sh 
```
1. Replace `jq` with `./jq-linux64` in [expsearch.sh](expsearch.sh)


## How to run
1. Make script executable
```
$ sudo chmod +x ./expsearch.sh 
```

2. Run script

```
$ ./expsearch.sh $1 $2 $@
```
- `$1` 
  -  *required*
  -  start date
     -  input `YYYY-MM-DD`
     -  goes back to 2016-10-10

- `$2`
  -  *required*
  -  end date
     -  input `YYYY-MM-DD`

- `$@`
  -  *required*
  -  search parameters
     -  *Swedish*
     -  case insensitive
     -  input `a-z`
        -  example
              -  köttbullar lingon gräddsås
              -  kyckling ris
     -  input `.` to list all
     -  logic
        -  exact match (whole words only)
           -  if input is "potatis", it will match "potatis" and not "potatismos"
        -  $1 and $2 and $3 ... ATM
        -  perhaps $1 or $2 or $3 ... in the future