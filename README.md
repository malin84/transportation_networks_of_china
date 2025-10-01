# Transportation Networks of China
This data repository hosts datasets covering China's road and rail transportation networks. These datasets are compiled in *The Distributional Impacts of Transportation Networks in China* by Lin Ma and Yang Tang, published in the *Journal of International Economics*. The published version of the paper is [here](https://www.sciencedirect.com/science/article/abs/pii/S0022199623001599?via%3Dihub), and the ungated working paper version is [here](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4118287).

The list of published academic papers that used this dataset is [here](https://github.com/malin84/transportation_networks_of_china/blob/main/Papers_Using_This_Dataset.md). 

To use the data, please cite:

"Lin Ma and Yang Tang. *The Distributional Impacts of Transportation Networks in China.* Journal of International Economics (2024): 103873."

<details>
  <summary>BibTex</summary>
  
  ```
  @article{MT2024_Transportation_China,
    title = {The Distributional Impacts of Transportation Networks in China},
    journal = {Journal of International Economics},
    pages = {103873},
    year = {2024},
    issn = {0022-1996},
    doi = {https://doi.org/10.1016/j.jinteco.2023.103873},
    url = {https://www.sciencedirect.com/science/article/pii/S0022199623001599},
    author = {Lin Ma and Yang Tang},
    keywords = {Regional trade, Migration, Welfare, Economic Geography},
    abstract = {We document that the quality of roads and railroads vary substantially over time and space in China, and neglecting these variations biases the distributional impacts of transportation       networks. To account for quality differences, we construct a new panel dataset and approximate quality using the design speed of roads and railroads that varies by vintage, class, and terrain at the pixel level. We then build a dynamic spatial general equilibrium model for multiple modes, transportation routes, and forward-looking migration decisions. Our findings demonstrate that disregarding     quality differences leads to a median bias of approximately 31% in estimating real wage growth rates at the prefecture level. Moreover, this bias is non-random and correlates with the initial conditions of the prefectures, resulting in significant errors when predicting the distributional effects of transportation networks.}
}
  ```
</details>

---
This dataset contains three components: 
  1) [Prefecture-to-Prefecture Travel Time](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#prefecture-to-prefecture-travel-time);
  2) [Pixel-Level Information: Design Speed and Travel Time](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#pixel-level-design-speed-and-travel-time);
  3) [Segment-Level Information: Name, Rate, Year of Construction, and Applicable Design Code](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#segment-level-information-name-year-of-construction-and-applicable-design-code).

The current version covers the transportation network between 1994 and 2017. 

The folder [sample_codes](sample_codes/) contains some sample codes for computing travel time between any pixels using Fast Marching. Please refer to the readme file in that folder for details. 


## Prefecture-to-Prefecture Travel Time

This data set records the prefecture-to-prefecture travel time in units of hours for three modes of transportation: road, railroad (freight), and railroad (passenger). The current version covers the years 1994 to 2017 and contains 279 prefectures. 

All the files are stored in the folder [pref_pair](pref_pair/).

The travel time is computed using the Fast Marching algorithm based on the pixel-level design speed. Ma and Tang (2024) provide more details on how to infer the pixel-level design speed and prefecture-to-prefecture travel time. 

The dataset contains the following files.
### Prefecture Information
`cityinfo.csv` file contains the basic information about the 279 prefectures.
  
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

### Distance files  

The following files contain the distance matrix:
1. `pref_pair/time_cost_prefecture_pair_rail_good.csv` contains the travel time for **freight** transportation on the **rail network**.
2. `pref_pair/time_cost_prefecture_pair_rail_pass.csv` contains the travel time for **passenger** transportation on the **rail network**.
3. `pref_pair/time_cost_prefecture_pair_road.csv` contains the travel time for both **freight** and **passenger** transportation on the **road network**.
   
The travel time data files share the same structure. Each file contains $38781$ rows, which is the lower triangle of the $279\times279$ symmetric distance matrix without the diagonal elements. The variables in these files are:  
1. The first two columns, `origin` and `destination,` are the four-digit admin codes of the origin and destination prefectures.
2. `year_yyyy`: the travel time between the two prefectures in the year `yyyy` in hours.


## Pixel-Level Design Speed and Travel Time

This data set contains the design speed of the roads and railroads on each **pixel** and the travel time to traverse these pixels in the $12669\times 8829$ raster map of China by year and transportation mode. We only include the pixels with infrastructure build-up. The user should specify a speed to traverse empty pixels without any infrastructure to compute point-to-point travel time. In Ma and Tang (2024), the empty traverse speed is 10km/h. 

The travel time estimations between any two points, including the prefecture-to-prefecture travel time database reported above, are computed based on this data set using the Fast Marching Algorithm. The folder [sample_codes](sample_codes/) contains examples of using these data to compute travel time between any two pixels.

All the files are stored in the folder [pixel_info](pixel_info/). The data files are named `pixel_info_MMMM_YYYY.csv,` where `MMMM` refers to the three modes of transportation: road, railroad (freight), and railroad (passenger), and `YYYY` refers to the year. 

Each row of the data file refers to a **pixel** with infrastructure build-up. The columns contain the following variables:
  
1. `seg_id`: the unique index of a segment that the pixel belongs to. The `seg_id` is the same as the segment-level dataset, with details [here](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#segment-level-information-name-year-of-construction-and-applicable-design-code).
2. `long`: the longitude of the pixel.
3. `lat`: the latitude of the pixel.
4. `pos_x`: the $x$ index in the 12669-by-8829 pixel-level matrix dataset.
5. `pos_y`: the $y$ index in the 12669-by-8829 pixel-level matrix dataset.
6. `index`: the index number of the pixel in the 12669-by-8829 matrix. The index number is the output of the following MATLAB function:
   ```matlab
   index=sub2ind([8829 12669],pos_y,pos_x)
   ```
7. `speed`: the design speed of the infrastructure on the pixel in kilometers per hour.
8. `time`: the time required to traverse the pixel in the unit of hours. See the note below on its computation.
9. `usage_type`: the usage type of the infrastructure that takes three values:
    1. `both` refers to mixed freight and passenger transportation usage. All road transportation and the majority of railroads fall into this category.
    2. `good` refers to freight-only railroad transportation.
    3. `pass` refers to passenger-only railroad transportation.
10. `terrain`: the terrain type of the pixel that takes four values. Refer to the Appendix to Ma and Tang (2024) for the terrain definition:
    1. `0`: coastal areas.
    2. `1`: plains.
    3. `2`: low-rolling hills.
    4. `3`: hills.
    5. `4`: mountains.
   
Notes:
1. To compute `time` from `speed,` the authors used the following equation: $time = 0.5(1+\sqrt{2})*distance/speed$. The variable $distance$ is computed based on the average distance to move to the four adjacent pixels. In most cases, the distance equals to 0.5097 km. The term $0.5(1+\sqrt{2})$ corrects for the fact that around half the time, travelers cross a pixel along the diagonal.

## Segment-Level Information: Name, Year of Construction, and Applicable Design Code

This data set records the information for roads and railroads at the **segment** level. A **segment** is a group of **pixels** that form part of a named road or railroad referred to as a **path** (such as the Beijing-Shanghai Railway or Beijing-Shijiazhuang Highway) constructed in a given year. Information that varies at the segment level includes rate, the year of construction, usage type, and design codes. See the detailed definitions of "segment" and "path" in Ma and Tang (2024).

All the files are stored in the folder [seg_info](seg_info/). We create three data files for each mode of transportation. These files are as follows:
1. [segment-level information](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#segment-level-information): year of construction, applicable standard, rates, and parent path.
2. [segment-year level information](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#segment-year-level-information): usage type by year.
3. [segment-pixel mapping](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#segment-pixel-mapping): the coordinates of each pixel within a segment.

### Segment Level Information

The file `seg_info_MMMM.csv` contains the segment-level information for the mode (`MMMM` = road or rail). Each row in the file refers to a **segment**. The columns are as follows:
1. `seg_id`: The unique id of the segment, which is the same as those used in the pixel-level dataset.
2. `rate`: The rate of the segment, such as "National I" for railroads or "First-Rate" for roads. See the subsection [below](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#railroad-and-road-rates) for more details.
3. `year`: The year of construction.
4. `year_std`: The publication year of the applicable design code. For example, highways built in 2010 were subject to the highway design codes published in 2003. In this case, `year` = 2010, and `year_std` = 2003. We did not assign `year_std` for HSR because we collected the design speed of each high-speed railway by hand. See the subsection [below](https://github.com/malin84/transportation_networks_of_china?tab=readme-ov-file#design-codes) for more details.
5. `path_name`: (in Chinese) The name of the path to which the segment belongs. For example, Segment `rail_10` is part of the "滨绥铁路," and therefore we record the name of the path in this variable.  
6. `path_supplement`: (in Chinese) Additional information about the path, such as original names, original usage, phases, etc. In the example above, the supplement information for `rail_10` is "原东清铁路东线."
7. `notes`: (in Chinese) Additional information about the segment, usually regarding the segment's endpoints. We record this information for quality control purposes. In the example above, the notes for `rail_10` is "海林到牡丹江."

#### Railroad and Road Rates

The variable `rate` in the dataset above records a codename for the rate of the railroad and roads. The details regarding the railroad rates in the dataset are as follows:

|`rate` | Full Name | Full Name in Chinese | Usage Type |
|----------|-----------|----------------------|------------|
|GT1       | National I| 国家I级铁路，客货共线            | mixed |
|GT2       | National II| 国家II级铁路，客货共线            | mixed |
|GT3       | National III| 国家III级铁路，客货共线           | mixed |
|GT4       | National IV| 国家IV级铁路， 客货共线(2012标准后)           | mixed |
|GT1G      | National I (Freights)| 国家I级铁路，货运            | freights |
|GT2G      | National II (Freights)| 国家II级铁路，货运            | freights |
|GT3G      | National III (Freights)| 国家III级铁路，货运           | freights |
|GT        | National Rail, Unknown Rate | 国家铁路, 等级未知           | mixed |
|HSR       | High-Speed Rail| 高速铁路            | passenger/mixed |
|DT1       | Local I| 地方I级铁路，客货共线            | mixed |
|DT2       | Local II| 地方II级铁路，客货共线            | mixed |
|DT3       | Local III| 地方III级铁路，客货共线           | mixed |
|DT1G      | Local I (Freights)| 地方I级铁路，货运            | freights/mixed |
|DT        | Local Rail, Unknown Rate | 地方铁路, 等级未知           | mixed |
|IT1       | Industrial I| 工业企业I级铁路            | freights/mixed |
|IT2       | Industrial II| 工业企业II级铁路            | freights/mixed |
|IT3       | Industrial III| 工业企业III级铁路           | freights/mixed |
|IT        | Industrial Rail, Unknown Rate| 工业企业铁路, 等级未知          | freights/mixed |
|UN        | Unknown Rate| 等级未知          | mixed |
|NA        | Non-Active| 废置铁路          | - |

Note that while some railroads were constructed as "freights" or "industrial" that were intended as freight-only routes, in reality, passenger services are also possible. We provide a detailed documentation of mixed usage of these railroads in the dataset.

The road rates in the dataset are as follows:

|`rate` | Full Name | Full Name in Chinese | Usage Type |
|----------|-----------|----------------------|------------|
|highway       | Highway| 高速公路           | mixed |
|first-rate       | First-Rate Road| 国家I级公路            | mixed |

#### Design Codes
The variable `year_std` records the publication year of the applicable design standard for a given segment. The detailed design standards are as follows:

| `year_std` | Full Name | Full Name in Chinese | Standard Code|Mode |
|----------|-----------|----------------------|-----|-------|
|1985       | Code for Design of Railway Line (1985) | 铁路线路设计规范 |GBJ90-85           | rail |
|1987       | Code for Design of Standard Railway Line for Industrial Firms | 工业企业标准轨距铁路线路设计规范 |GBJ12-87           | rail |
|1999       | Code for Design of Railway Line (1999) | 铁路线路设计规范 |GB50090-99           | rail |
|2006       | Code for Design of Railway Line (2006) | 铁路线路设计规范 |GB50090-2006           | rail |
|2012       | Code for Design of III and IV Rated Railway Line | III、IV级铁路设计规范 |GB50012-2012           | rail |
|2017       | Code for Design of Railway Line (2017) | 铁路线路设计规范 |TB10098-2017           | rail |
|1988 | Technical Standard of Highway Engineering (1988) | 公路工程技术标准 | JTJ01-88 | road|
|1997 | Technical Standard of Highway Engineering (1997) | 公路工程技术标准 | JTJ01-97 | road|
|2003 | Technical Standard of Highway Engineering (2003) | 公路工程技术标准 | JTG B01-2003 | road|
|2014 | Technical Standard of Highway Engineering (2014) | 公路工程技术标准 | JTG B01-2014 | road|


---

### Segment-Year Level Information 

The file `seg_year_MMMM.csv` contains the segment-year level information. In the current version, the only variable that varies at this level is the usage type of railroads. Several railroads switched between "mixed-use" and "freight-only" during our sample period. Each row in the file refers to a **segment**. The columns are as follows:

1. `seg_id`: the unique segment id.
2. `year_type_YYYY`: the usage type of the segment in the year `YYYY.` `type= none` indicates that the road or railroad was no longer used that year.

---
### Segment-Pixel Mapping
The file `seg_pixel_MMMM.csv` contains the mapping between segments and pixels for mode `MMMM.` Each row in the file refers to a **pixel**. The columns are as follows:

1. `seg_id`: the unique id of the segment to which the pixel belongs.
2. `long`: the longitude of the pixel.
3. `lat`: the latitude of the pixel.
4. `pos_x`: the $x$ index in the 12669-by-8829 raster map.
5. `pos_y`: the $y$ index in the 12669-by-8829 raster map.
6. `index`: the index number of the pixel in the 12669-by-8829 raster map. The index number is the output of the following MATLAB function:
   ```matlab
   index=sub2ind([8829 12669],pos_y,pos_x)
   ```

