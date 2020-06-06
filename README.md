# Chalmers Expressen CLI
Outputs Chalmers Expressen history, e.g. how often Meatballs (Köttbullar) has been on the Expressen menu `:)`


## Description
Gets, maps, sorts & outputs historic data from expressen [api](https://chalmerskonferens.se/en/api/).


## Demo
<img src="demo.gif" width="640">


## How to run
```
$ ./expsearch.sh <FROM_DATE> <TO_DATE> <INGREDIENTS>|.
```
- `<FROM_DATE>` 
  -  *required*
  -  Start date
     -  Input `YYYY-MM-DD`
     -  Goes back to 2016-10-10

- `<TO_DATE>`
  -  *required*
  -  End date
     -  Input `YYYY-MM-DD`

- `<INGREDIENT> | .`
  -  *required*
  -  Search parameters
     -  *Swedish*
     -  Case insensitive
     -  Input `a-z`
        -  Example
              -  `köttbullar lingon gräddsås`
              -  `kyckling ris`
              -  `ris`
     -  Input `.` to list all
     -  How it works
        -  Exact match (whole words only)
           -  If input is `potatis`, it will match `potatis` and not `potatismos`
        -  `<INGREDIENT_1>` AND `<INGREDIENT_2>` AND `<INGREDIENT_3>` ... ATM
        -  Might add Perhaps `<INGREDIENT_1>` OR `<INGREDIENT_2>` ... in the future