# The variables in `pref_pair/cityinfo.csv`

The file `pref_pair/cityinfo.csv` contains the basic information of the 279 prefectures in China included in the prefecture-to-prefecture travel time dataset.

The file contains the following columns:

1. `id`: the index of a prefecture.
2. `dzcode`: the four-digit administrative division code.
3. `coord_long`: the longitude.
4. `coord_lat`: the latitude.
5. `pos_x`: the $x$ index in the 12669-by-8829 pixel-level matrix dataset.
6. `pos_y`: the $y$ index in the 12669-by-8829 pixel-level matrix dataset.
7. `cityname_chn`: prefecture name in Chinese.
8. `cityname_eng`: prefecture name in English.
9. `cpop2000`: total population in the unit of *ten-thousands*, 2000 census.
10. `cpop2010`: total population in the unit of *ten-thousands*, 2010 census.
11. `upop2000`: urban population in the unit of *ten-thousands*, 2000 census.
12. `upop2010`: urban population in the unit of *ten-thousands*, 2010 census.
13. `cityclass`: official city size classification based on the 2010 census:
    1. `cityclass` = 7: Mega City (超大城市), with an urban population greater than 10 million.
    2. `cityclass` = 6: Major City (特大城市), with an urban population between 5 and 10 million.
    3. `cityclass` = 5: Type-I Large City (I型大城市), with an urban population between 3 and 5 million.
    4. `cityclass` = 4: Type-II Large City (II型大城市), with an urban population between 1 and 3 million.
    5. `cityclass` = 3: Medium City (中等城市), with an urban population between 500 thousand and 1 million.
    6. `cityclass` = 2: Type-I Small City (I型小城市), with an urban population between 200 and 500 thousand.
    7. `cityclass` = 1: Type-II Small City (II型小城市), with an urban population smaller than 200 thousand.     
