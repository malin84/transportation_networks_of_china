# Transportation Networks of China
This data repository hosts datasets covering China's road and rail transportation networks. These datasets are compiled in *The Distributional Impacts of Transportation Networks in China* by Lin Ma and Yang Tang, published in the *Journal of International Economics*. To use the data, please cite:

"Lin Ma and Yang Tang. *The Distributional Impacts of Transportation Networks in China.* Journal of International Economics (2024): 103873."

This dataset contains three components: 
  1) [Prefecture-to-Prefecture Travel Time](https://github.com/malin84/transportation_networks_of_china/blob/main/README.md#prefecture-to-prefecture-travel-time);
  2) [Year of Construction and Applicable Design Code](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#year-of-construction-and-applicable-design-code);
  3) [Pixel-Level Design Speed and Travel Time](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#pixel-level-design-speed-and-travel-time).
   
The authors are still in the process of cleaning up parts (2) and (3), and you can access the raw data via the [Dropbox Link](https://www.dropbox.com/scl/fo/6cey5kdtqsfqyatn6xa43/h?rlkey=ycklu6jgstjlkiu2fa740iv21&dl=0) 

## Prefecture-to-Prefecture Travel Time

This data set records the prefecture-to-prefecture travel time in units of hours for three modes of transportation: road, railroad (freight), and railroad (passenger). The current version covers the years 1994 to 2017 and contains 279 prefectures. 

All the files are stored in the folder [pref_pair](pref_pair/).

The travel time is computed using the Fast Marching algorithm based on the pixel-level design speed. Ma and Tang (2024) provide more details on how to infer the pixel-level design speed and prefecture-to-prefecture travel time. 

The dataset contains the following files.
### Prefecture Information
`cityinfo.csv` is the file that contains the basic information about the 279 prefectures.
<details> 
<summary>Variable Definition</summary>
  
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
</details>

### Distance files  

The following files contain the distance matrix:
1. `pref_pair/time_cost_prefecture_pair_rail_good.csv` is the travel time for **freight** transportation on the **rail network**.
2. `pref_pair/time_cost_prefecture_pair_rail_pass.csv` is the travel time for **passenger** transportation on the **rail network**.
3. `pref_pair/time_cost_prefecture_pair_road.csv` is the travel time for both **freight** and **passenger** transportation on the **road network**.
   
The travel time data files share the same structure. Each file contains $38781$ rows, which is the lower triangle of the $279\times279$ symmetric distance matrix without the diagonal elements. The variables in these files are:  
1. The first two columns, `origin` and `destination,` are the four-digit admin codes of the origin and destination prefectures.
2. `year_yyyy`: the travel time between the two prefectures in the year `yyyy` in hours.

## Year of Construction and Applicable Design Code

This data set records the years of construction and the applicable design codes for all segments of roads and railroads in the dataset.

## Pixel-Level Design Speed and Travel Time

This data set contains the design speed and the travel time to traverse the pixels with infrastructure build-up in the $12669\times 8829$ raster map of China by year and transportation mode. The prefecture-to-prefecture travel time is computed based on this data set using the Fast Marching Algorithm.

All the files are stored in the folder [pixel_info](pixel_info/). The data files are named `pixel_info_MMMM_YYYY.csv,` where `MMMM` refers to the three modes of transportation: road, railroad (freight), and railroad (passenger), and `YYYY` refers to the year. Each row of the data file refers to a pixel with infrastructure build-up. 

<details> 
<summary>Variable Definition</summary>
  
1. `path_id`: the unique index of a path that the pixel belongs to. The `path_id` is the same as the path-level dataset that records the years of construction and the applicable design codes.
2. `long`: the longitude of the pixel.
3. `lat`: the latitude of the pixel.
4. `pos_x`: the $x$ index in the 12669-by-8829 pixel-level matrix dataset.
5. `pos_y`: the $y$ index in the 12669-by-8829 pixel-level matrix dataset.
7. `speed`: the design speed of the infrastructure on the pixel in kilometers per hour.
8. `time`: the time required to traverse the pixel in the unit of hours. See the note below on its computation.
9. `type`: the type of the infrastructure that takes three values:
    1. `both` refers to mixed freight and passenger transportation usage. All road transportation is mixed.
    2. `good` refers to freight transportation.
    3. `pass` refers to passenger transportation.
10. `terrain_type`: the terrain type of the pixel, takes four values:
    1. `0`: coastal areas.
    2. `1`: plains.
    3. `2`: low-rolling hills.
    4. `3`: hills.
    5. `4`: mountains.
   
Notes:
1. The user should specify a speed to traverse empty pixels without any infrastructure to compute point-to-point travel time. In Ma and Tang (2024), the empty traverse speed is 10km/h.
2. To compute `time` from `speed,` the authors used the following equation: $time = (1+\sqrt{2}/2)*distance/speed$. The variable $distance$ is computed based on the average distance to move to the four adjacent pixels. In most cases, the distance equals to $0.5097$km. The term $(1+\sqrt{2}/2)$ corrects for the fact that around half of the time, travelers cross a pixel along the diagonal.

</details>

