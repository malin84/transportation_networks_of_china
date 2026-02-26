This file includes documentation for newly added routes, updates to the algorithm for computing the shortest commuting time between cities, and corrections to existing routes.

# New data: 2018 to 2024

We have added new data for 2018–2024, covering high-speed rail (HSR), rail, highways, and national roads. The following section describes the data sources, including the primary source and supplementary sources.

## Main source
| Year | Revision Date | Scale |Publisher
|------|---------------|-------|-----------|
| 2018 | January 2019  | 1:4,500,000 |China Map Press|
| 2019 | January 2020  | 1:6,000,000 |China Map Press|
| 2020 | January 2021  | 1:4,500,000 |China Map Press|
| 2021 | January 2022  | 1:4,500,000 |China Map Press|
| 2022 | January 2023  | 1:4,500,000 |China Map Press|
| 2023 | July 2024     | 1:6,000,000 |China Map Press|
| 2024 | January 2025  | 1:6,000,000 |China Map Press|

## Other sources

### China Transportation Atlas (Revised April 2025 and March 2023)

# Change to algorithm

We initially used the **Fast Marching Method (FMM)** to generate travel-time (or distance) fields. FMM formulates the propagation process via the Eikonal equation $|\nabla T(\mathbf{x})|,F(\mathbf{x})=1$ and advances the wavefront using a **narrow-band** strategy with an **upwind discretization**. When the speed field $F(\mathbf{x})$ is smooth and strictly positive and the discretization is monotone, FMM provides an efficient approximation to an isotropic, continuous “all-directions” travel-time solution. However, under our rasterized network representation and year-to-year comparison framework, FMM exhibits an unacceptable drawback: **excessive sensitivity of the numerical solution to local structural perturbations**. Even when a given road segment does not change, construction or modification of nearby roads alters the set of globally optimal routes; in our implementation, the narrow-band marching procedure relies on local updates and acceptance order, and such structural changes can induce unstable reordering of wavefront updates, leading to disproportionate fluctuations in travel times for some areas and reducing reproducibility and comparability across years. Because our analysis critically relies on robust measurement of annual network changes, this sensitivity constitutes a methodological bottleneck.

To address this limitation, we replace FMM with **Dijkstra’s shortest-path algorithm** on a discrete raster graph to compute minimum-cost travel times. Dijkstra’s method uses a global priority queue and “settles” nodes in non-decreasing cost order, guaranteeing global optimality under the specified neighborhood connectivity and edge weights. Relative to the FMM-based continuous-wavefront approximation and its local update mechanism, this graph-search formulation provides more consistent behavior under local network modifications and substantially improves reproducibility in our setting. We adopt **8-neighborhood** connectivity (horizontal, vertical, and diagonal moves) to mitigate the strong directional bias of 4-neighborhood grids. Although 8-neighborhood propagation is still a discrete approximation to continuous “all-directions” propagation and may introduce path-length–accumulating grid-metric anisotropy, our empirical comparison shows that the **year-over-year (YoY) differences** between the two versions are small overall, indicating that the discretization-induced deviations are well controlled at the current grid resolution and cost-field specification and do not materially affect the key quantitative conclusions regarding annual changes.

Importantly, adopting Dijkstra’s algorithm does not impose a prohibitive computational burden in our setting. We implement a multi-source variant that substantially reduces runtime. Overall, multi-source Dijkstra offers a targeted remedy for the critical robustness issue observed with FMM, while maintaining acceptable computational cost and improving **stability**, reproducibility, and cross-year comparability.

# Changes to 2017 and earlier data

This section outlines updates to roads built prior to 2017, focusing on three main areas: previously omitted roads, changes in road type, and other adjustments.

## Previously omitted

### Rail and HSR

**1917**

* In **1917**, in **Jiangsu**, the **Qianjia Railway** runs from **Xuzhou Qianting to Jiawang** and serves **both passenger and freight**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E5%89%8D%E8%B4%BE%E9%93%81%E8%B7%AF/6282524) / [Wikipedia](https://zh.wikipedia.org/wiki/%E5%89%8D%E8%B4%BE%E9%93%81%E8%B7%AF)**.

**1965**

* In **1965**, in **Heilongjiang**, the **Xinglong Forestry Bureau Forest Railway (Tourist railway)** runs from **Wuyapao Town (Tonghe County, Harbin) to Xinglong Town (Bayan County, Harbin)** as a **passenger line**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%85%B4%E9%9A%86%E6%9E%97%E4%B8%9A%E5%B1%80%E6%A3%AE%E6%9E%97%E9%93%81%E8%B7%AF)**.

**1970**

* In **1970**, in **Liaoning**, the **Chaoma Railway** runs from **Chaoyang to Mashan** and is **freight-only** with a design speed of **60 km/h**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E6%9C%9D%E9%A9%AC%E9%93%81%E8%B7%AF/15891454?fromModule=lemma_inlink)**.

**1971**

* In **1971**, in **Jiangxi**, the **Shangrao–Xinyu Railway** runs from **Shanggao to Xinyu** and is **freight-only**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E4%B8%8A%E6%96%B0%E9%93%81%E8%B7%AF/20306590)**.

**1982**

* In **1982**, in **Heilongjiang**, the **Fuqian Railway** (noted as splitting at Tongjiang with different routes) runs from **Fujin to Tongjiang** and serves **both passenger and freight**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E7%A6%8F%E5%89%8D%E9%93%81%E8%B7%AF)**.

**1987**

* In **1987**, in **Henan**, the **Shangmang Narrow-Gauge Railway Line** (marked **Abandoned**) ran from **Xiayi to Suixi** and carried **freight**. Sources: **[1976 – Henan Party History and Local Gazetteer Website](./1976年-河南党史方志网.pdf)**.

**1999**

* In **1999**, in **Jiangxi**, the **Fengfu Railway (Shangqian Line)** runs from **Shangqian to Shangrao** and serves **both passenger and freight**. Sources: **Provincial map atlas (2022) / [Wikipedia](https://zh.wikipedia.org/wiki/%E5%B3%B0%E7%A6%8F%E9%93%81%E8%B7%AF) / yearbook**; Page 83; **China Transportation Yearbook 2000 p.74**.

**2001**

* In **2001**, in **Guangdong**, the **Yangyang Railway (Guangmao Railway Branch Line)** runs from **Yangchun to Yangjiang** and is **freight-only** with a design speed of **80 km/h**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E9%98%B3%E9%98%B3%E9%93%81%E8%B7%AF/1860577) / [Wikipedia](https://zh.wikipedia.org/wiki/%E9%98%B3%E9%98%B3%E9%93%81%E8%B7%AF)**.

**2003**

* In **2003**, in **Heilongjiang**, the **Suidong Railway** runs from **Suiyangzhen Hexi to Dongning** and is **freight-only** with a design speed of **80 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E7%BB%A5%E4%B8%9C%E9%93%81%E8%B7%AF)**.

**2006**

* In **2006**, in **Neimenggu**, the **Huzhun Railway** runs from **Jungar Banner to Hohhot** and is **freight-only** with a design speed of **80 km/h**. Sources: **[Wikipedia1](https://zh.wikipedia.org/wiki/%E5%91%BC%E5%87%86%E9%93%81%E8%B7%AF) /[Wikipedia2](https://zh.wikipedia.org/wiki/%E5%91%BC%E5%87%86%E9%84%82%E9%93%81%E8%B7%AF)/ [Baidu Baike](https://baike.baidu.com/item/%E5%91%BC%E5%87%86%E9%84%82%E9%93%81%E8%B7%AF/6839217)**.
* In **2006**, in **Hebei**, the **Huangwan Railway** runs from **Huanghua to Wanjia Wharf (Binhai New Area, Tianjin)** and is **freight-only**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E9%BB%84%E4%B8%87%E9%93%81%E8%B7%AF/5907931)**.

**2008**

* In **2008**, in **Jilin**, the **Changshuangyan Railway** runs from **Changchun to Yantongshan**, serves **both passenger and freight**, and has a design speed of **80 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%95%BF%E5%8F%8C%E7%83%9F%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E9%95%BF%E5%8F%8C%E7%83%9F%E9%93%81%E8%B7%AF/5510597)**.

**2009**

* In **2009**, in **Shandong**, the **Bingang Railway** runs from **Lijin to Zhanhua** and is **freight-only** with a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%BB%A8%E6%B8%AF%E9%93%81%E8%B7%AF)**.
* In **2009**, in **Shandong**, the **Bingang Railway** runs from **Xiaoying to Lijin** and is **freight-only** with a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%BB%A8%E6%B8%AF%E9%93%81%E8%B7%AF)**.
* In **2009**, in **Neimenggu**, the **Chidaibai Railway** ran from **Balin Right Banner to Chifeng** as **freight-only** at **120 km/h**, with a note that **passenger services began in 2024** and **“both” applies only from then on**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E8%B5%A4%E5%A4%A7%E7%99%BD%E9%93%81%E8%B7%AF/4974193)**.
* In **2009**, in **Neimenggu**, the **Chidaibai Railway** ran from **Bayinhua to Balin Right Banner** as **freight-only** at **120 km/h**, with a note that **passenger services began in 2024** and **“both” applies only from then on**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E8%B5%A4%E5%A4%A7%E7%99%BD%E9%93%81%E8%B7%AF/4974193)**.
* In **2009**, in **Neimenggu**, the **Guobai Railway** runs from **Guoerben Aobao Station to Manglai Coal Mine (Baiyinwula Coalfield, within Sonid Left Banner)** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%83%AD%E7%99%BD%E9%93%81%E8%B7%AF) / [website](https://www.zhulong.com/bbs/d/20708149.html)**.

**2010**

* In **2010**, in **Neimenggu**, the **Baoman Railway (Baibai Section)** runs from **Bayinhua to Baiyun'ebo Mining Area**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E7%99%BD%E5%B7%B4%E9%93%81%E8%B7%AF/5268636?fromModule=lemma_inlink) / [Wikipedia](https://zh.wikipedia.org/wiki/%E5%8C%85%E6%BB%A1%E9%93%81%E8%B7%AF)**.
* In **2010**, in **Neimenggu**, the **Baoxi Railway** runs from **Xinjie to Dabaodang**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%8C%85%E8%A5%BF%E9%93%81%E8%B7%AF)**.
* In **2010**, in **Neimenggu**, the **Baoxi Railway** runs from **Ordos to Xinjie**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%8C%85%E8%A5%BF%E9%93%81%E8%B7%AF)**.
* In **2010**, in **Neimenggu**, the **Xijin Line** runs from **Xixiaozhao to Jinquan** and is **freight-only** with a design speed of **120 km/h**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E8%A5%BF%E7%94%98%E9%93%81%E8%B7%AF/15525945)**.
* In **2010**, in **Guangxi**, the **Tianjing Railway (Tiande Railway)** runs from **Tiandong to Debao**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E7%94%B0%E9%9D%96%E9%93%81%E8%B7%AF)**.

**2011**

* In **2011**, in **Qinghai**, the **Chaimu Railway** runs from **Chaidar to Muli** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%9F%B4%E6%9C%A8%E9%93%81%E8%B7%AF) / Provincial map atlas**.
* In **2011**, in **Jilin**, the **Taoshu Railway** runs from **Yushu to Shulan** and serves **both passenger and freight**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%99%B6%E8%88%92%E9%93%81%E8%B7%AF) / yearbook; China Railway Yearbook 2008**.
* In **2011**, in **Ningxia**, the **Taiyuan–Zhongwei–Yinchuan Railway** runs from **Lingwu to Dingbian**, serves **both passenger and freight**, and has a design speed of **160 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%A4%AA%E4%B8%AD%E9%93%B6%E9%93%81%E8%B7%AF)**.
* In **2011**, in **Guangdong**, the **Guangzhou–Shenzhen–Hong Kong High-Speed Railway** runs from **Shunde to Shenzhen** as a **passenger line** with a design speed of **350 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%BB%A3%E6%B7%B1%E6%B8%AF%E9%AB%98%E9%80%9F%E9%90%B5%E8%B7%AF)**.

**2012**

* In **2012**, in **Neimenggu**, the **Xin’en’tao Railway** runs from **Uxin Banner to Xinjie** and is **freight-only**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E6%96%B0%E6%81%A9%E9%99%B6%E9%93%81%E8%B7%AF/3301917)**.
* In **2012**, in **Guangxi**, the **Tianjing Railway (Dejing Railway)** runs from **Debao to Jingxi**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E7%94%B0%E9%9D%96%E9%93%81%E8%B7%AF)**.
* In **2012**, in **Neimenggu**, the **Ganquan Railway** runs from **Ganqimaodu Station to Jinquan** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E7%94%98%E6%B3%89%E9%93%81%E8%B7%AF)**.
* In **2012**, in **Neimenggu**, the **Ganquan Railway** runs from **Jinquan to Wanshuiquan South Station** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E7%94%98%E6%B3%89%E9%93%81%E8%B7%AF)**.

**2013**

* In **2013**, in **Gansu**, the **Xiping Railway** runs from **Pingliang to Bin County**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E8%A5%BF%E5%B9%B3%E9%93%81%E8%B7%AF)**.
* In **2013**, in **Jiangsu**, the **Fengpei Railway** runs from **Pei County to Shouxian**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E4%B8%B0%E6%B2%9B%E9%93%81%E8%B7%AF/4289119?fromtitle=%E4%B8%B0%E6%B2%9B%E7%BA%BF&fromid=3989425)**.
* In **2013**, in **Hebei**, the **Hanhuang Railway** runs from **Cangzhou Nanpi to Cangzhou Haixing**, serves **both passenger and freight**, and has a design speed of **160 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%82%AF%E9%BB%84%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E9%82%AF%E9%BB%84%E9%93%81%E8%B7%AF/184512)**.
* In **2013**, in **Anhui**, the **Suhuai Railway** runs from **Siyang to Huai'an**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%AE%BF%E6%B7%AE%E9%93%81%E8%B7%AF)**. Note that the Type changes to **both** starting in 2014.
* In **2013**, in **Anhui**, the **Suhuai Railway** runs from **Fuliji to Siyang**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%AE%BF%E6%B7%AE%E9%93%81%E8%B7%AF)**. Note that the Type changes to **both** starting in 2014.
* In **2013**, in **Anhui**, the **Fuliu Railway** runs from **Fuyang to Lu’an**, serves **both passenger and freight**, and has a design speed of **160 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%98%9C%E5%85%AD%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E9%98%9C%E5%85%AD%E9%93%81%E8%B7%AF/7172628)**.
* In **2013**, in **Guangxi**, the **Qinfang Railway** runs from **Qinzhou to Fangchenggang**, serves **both passenger and freight**, and has a design speed of **250 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%92%A6%E9%98%B2%E9%93%81%E8%B7%AF)**.
* In **2013**, in **Hebei**, the **Hanhuang Railway** runs from **Jizhou District (Hengshui) to Nanpi (Cangzhou)**, serves **both passenger and freight**, and has a design speed of **160 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%82%AF%E9%BB%84%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E9%82%AF%E9%BB%84%E9%93%81%E8%B7%AF/184512)**.
* In **2013**, in **Hebei**, the **Hanhuang Railway** runs from **Xingtai to Jizhou District (Hengshui)**, serves **both passenger and freight**, and has a design speed of **160 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%82%AF%E9%BB%84%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E9%82%AF%E9%BB%84%E9%93%81%E8%B7%AF/184512)**.

**2014**

* In **2014**, in **Neimenggu**, the **Bazhu Railway** runs from **Dong Ujimqin Banner Station to the China–Mongolia border**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%B7%B4%E7%8F%A0%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E5%B7%B4%E7%8F%A0%E9%93%81%E8%B7%AF/3902820)**.
* In **2014**, in **Neimenggu**, the **Bazhu Railway** runs from **Dong Ujimqin Banner Station to Bayanwula Station**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%B7%B4%E7%8F%A0%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E5%B7%B4%E7%8F%A0%E9%93%81%E8%B7%AF/3902820)**.
* In **2014**, in **Neimenggu**, the **Zhuzhu Railway** runs from **Wuzhumuqin Station to Zhusihua Station** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E7%8F%A0%E7%8F%A0%E9%93%81%E8%B7%AF)**.
* In **2014**, in **Shanxi**, the **Taixing Railway** runs from **Baiwen to Lan County** as **freight-only** at **160 km/h**, with a note that **passenger services began in 2018** and **“both” applies only from then on**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%A4%AA%E5%85%B4%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E5%A4%AA%E5%85%B4%E9%93%81%E8%B7%AF/9047622)**.

**2015**

* In **2015**, in **Gansu**, the **Lanzhou–Zhongchuan Airport intercity railway** serves **Zhongchuan Airport** as a **passenger line** with a design speed of **160 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E4%B8%AD%E5%B7%9D%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Liaoning**, the **Dandong–Dalian Intercity Railway** runs from **Dandong to Dalian**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E4%B8%B9%E5%A4%A7%E5%9F%8E%E9%99%85%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Gansu**, the **Lanzhou–Zhongchuan Airport intercity railway** runs from **Lanzhou Fuli District to Zhongchuan Airport** as a **passenger line** with a design speed of **160 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E4%B8%AD%E5%B7%9D%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Neimenggu**, the **Xi’er Railway** runs from **Zhuncha’gan Aobao Station to Xili Station**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%94%A1%E4%BA%8C%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Sichuan**, the **Lanzhou–Chongqing railway** runs from **Nanchong to Chongqing**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%85%B0%E6%B8%9D%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Sichuan**, the **Lanzhou–Chongqing railway** runs from **Guangyuan to Nanchong**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%85%B0%E6%B8%9D%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Hebei**, the **Jinbao Railway** runs from **Langfang Bazhou to Baoding Xushui District**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%B4%A5%E4%BF%9D%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E6%B4%A5%E4%BF%9D%E9%93%81%E8%B7%AF/4747197)**.
* In **2015**, in **Neimenggu**, the **Baxin Railway** runs from **Daban North Station to Kouhezi** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%B7%B4%E6%96%B0%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Anhui**, the **Ningan Passenger Dedicated Line** runs from **Anqing to Chizhou** as a **passenger line** with a design speed of **250 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%AE%81%E5%AE%89%E5%AE%A2%E8%BF%90%E4%B8%93%E7%BA%BF)**.
* In **2015**, in **Neimenggu**, the **Baxin Railway** runs from **Bayanwula Station to Daban North Station** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%B7%B4%E6%96%B0%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Neimenggu**, the **Baxin Railway** runs from **Kouhezi to Fuxin** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%B7%B4%E6%96%B0%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Hainan**, the **Hainan Island High-Speed Railway (Hainan West Ring High-Speed Railway)** runs from **Haikou to Sanya**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%B5%B7%E5%8D%97%E8%A5%BF%E7%8E%AF%E9%AB%98%E9%80%9F%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Gansu**, the **Tianping Railway** runs from **Tianshui to Pingliang**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E5%A4%A9%E5%B9%B3%E9%93%81%E8%B7%AF/5146433)**.
* In **2015**, in **Guangxi**, the **Yutie Railway** runs from **Yulin to Tieshangang District**, serves **both passenger and freight**, and has a design speed of **160 km/h**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E7%8E%89%E9%93%81%E9%93%81%E8%B7%AF/9613254) / [China Railway (CRECG)](https://www.crecg.com/web/xwzx61/zfgsdt39/2025021110085272430/index.html)**.
* In **2015**, in **Neimenggu**, the **Xiwu Railway** runs from **Zhushihua Station to Bayinhua South Station**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%94%A1%E4%B9%8C%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Neimenggu**, the **Xiwu Railway** runs from **Xiwuqi Station to Bayinhua South Station**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%94%A1%E4%B9%8C%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Neimenggu**, the **Xiwu Railway** runs from **Xilinhot Station to Zabuqier Station**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%94%A1%E4%B9%8C%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Neimenggu**, the **Xi’er Railway** is recorded at the **Xilin Gol League** level as serving **both passenger and freight** with a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%94%A1%E4%BA%8C%E9%93%81%E8%B7%AF)**.
* In **2015**, in **Neimenggu**, the **Xi’er Railway** runs from **Xilin Gol League to Zhunchagan Aobao Station**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%94%A1%E4%BA%8C%E9%93%81%E8%B7%AF)**.

**2016**

* In **2016**, in **Guangdong**, the **Guangzhou–Zhaoqing intercity railway** runs from **Foshan to Zhaoqing** as a **passenger line** with a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%B9%BF%E8%82%87%E5%9F%8E%E9%99%85%E9%93%81%E8%B7%AF)**.
* In **2016**, in **Chongqing**, the **Chongqing–Wanzhou Intercity Railway** runs from **Liangping to Wanzhou North** as a **passenger line** with a design speed of **250 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%B8%9D%E4%B8%87%E5%9F%8E%E9%99%85%E9%93%81%E8%B7%AF)**.
* In **2016**, in **Chongqing**, the **Chongqing–Wanzhou Intercity Railway** runs from **Chongqing North to Liangping** as a **passenger line** with a design speed of **250 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%B8%9D%E4%B8%87%E5%9F%8E%E9%99%85%E9%93%81%E8%B7%AF)**.
* In **2016**, in **Guizhou**, the **Huyong Railway** runs from **Huchao to Nayong West**, serves **both passenger and freight**, and has a design speed of **120 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%B9%96%E9%9B%8D%E9%93%81%E8%B7%AF)**.
* In **2016**, in **Neimenggu**, the **Hulan Railway (Duofeng Railway)** runs from **Duolun County to Fengning** and is **freight-only** with a design speed of **120 km/h**. Sources: **[Baidu Baike1](https://baike.baidu.com/item/%E5%A4%9A%E4%B8%B0%E9%93%81%E8%B7%AF/15110183) / [Baidu Baike2](https://baike.baidu.com/item/%E8%99%8E%E8%93%9D%E9%93%81%E8%B7%AF/9996028)/[Wikipedia](https://zh.wikipedia.org/wiki/%E5%A4%9A%E4%B8%B0%E9%93%81%E8%B7%AF)**.
* In **2016**, in **Hubei**, the **Wuhan--Shiyan High-Speed Railway** runs from **Hankou to Xiaogan** as a **passenger line** with a design speed of **200 km/h**. Sources: **[Baidu Baike](https://baike.baidu.com/item/%E6%B1%89%E5%8D%81%E9%AB%98%E9%80%9F%E9%93%81%E8%B7%AF/16817250)**.


**2017**

* In **2017**, in **Gansu**, the **Lanzhou–Chongqing railway** runs from **Lanzhou to Guangyuan** and serves **both passenger and freight**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%85%B0%E6%B8%9D%E9%93%81%E8%B7%AF) / China Railway Yearbook p.102 / Provincial Map Atlas (Gansu 18)**.
* In **2017**, in **Zhejiang**, the **Quzhou–Jiujiang Railway** runs from **Quzhou to Wuyuan**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E8%A1%A2%E4%B9%9D%E9%93%81%E8%B7%AF).**
* In **2017**, in **Shandong**, the **Longyan Railway** runs from **Longkou to Yantai**, serves **both passenger and freight**, and has a design speed of **160 km/h**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%BE%99%E7%83%9F%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E9%BE%99%E7%83%9F%E9%93%81%E8%B7%AF/2762094)**.

### Highway and National Road

**2013**

* In **2013**, **Shandong** added a new **highway segment** in **Heze**.

**2017**
* In **2017**, **Hunan** added a new **highway segment** in **Zhuzhou**.
* In **2017**, **Hebei** added a new **highway segment** in **Qinhuangdao**.
* In **2017**, **Zhejiang** added **two** new **highway segments** in **Hangzhou**.
* In **2017**, **Fujian** added a new **highway segment** in **Luoyuan**.

## Type changes

### Rail and HSR

**1903**

* In **1903**, in **Hebei**, the **Gaoyi Railway** runs from **Gaobeidian to Yi County** and had a service pattern of **goods → both (from 2000) → goods → none (after 2013, out of service)**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%96%B0%E6%98%93%E9%90%B5%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E9%AB%98%E6%98%93%E7%BA%BF/11040519)**.

**1945**

* In **1945**, in **Jilin**, the **Tuanshan Railway** runs from **Huinan to Shansonggang** and is **freight-only**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%9B%A2%E6%9D%89%E9%93%81%E8%B7%AF)**.

**1958**

* In **1958**, in **Hubei**, the **Tieling Railway** runs from **Tieshan to Lingxiang** and is **freight-only**. Sources: **[Wikipedia1](https://zh.wikipedia.org/wiki/%E9%93%81%E5%B1%B1%E7%AB%99_%28%E9%BB%84%E7%9F%B3%E5%B8%82%29)/[Wikipedia2](https://zh.wikipedia.org/wiki/%E9%93%81%E7%81%B5%E9%93%81%E8%B7%AF)**.

**1959**

* In **1959**, in **Henan**, the **Anli Railway** includes the **Heshun** section and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%AE%89%E6%9D%8E%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E5%AE%89%E6%9D%8E%E9%93%81%E8%B7%AF/9867405)**.
* In **1959**, in **Henan**, the **Anli Railway** runs from **Anyang to Gangziyao** and is **freight-only**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%AE%89%E6%9D%8E%E9%93%81%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E5%AE%89%E6%9D%8E%E9%93%81%E8%B7%AF/9867405)**.

**1960**

* In **1960**, in **Hunan**, the **Tunqiu Railway** runs from **Liuzhou to Ladong** and had a service pattern of **both → none → both**, with a note that it **reopened in 2016 after nearly 20 years out of service**. Source: **[Baidu Baike](https://baike.baidu.com/item/%E5%B1%AF%E7%A7%8B%E6%94%AF%E7%BA%BF/13024645)**.

**1966**

* In **1966**, in **Jiangxi**, the **Xiangle Railway** (a **Zhegan Railway branch line**) runs from **Fengcheng to Jiangbiancun**, and it is recorded as **both → none**, with a note that it has been **out of service since 2013**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%90%91%E4%B9%90%E9%93%81%E8%B7%AF)**.

**1968**

* In **1968**, in **Sichuan**, the **Yigong Railway** runs from **Yibin to Gong County**, and it is recorded as **both → goods**, with a note that **passenger services were discontinued in 2010**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%AE%9C%E7%8F%99%E9%93%81%E8%B7%AF)**.

**1970**
* In **1970**, in **Guangxi**, the **Sanluo Railway** serves **Luocheng**, and it is recorded as **both → goods**, with a note that **passenger services were discontinued in 2005**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E4%B8%89%E7%BD%97%E9%93%81%E8%B7%AF)**.
* In **1970**, in **Sichuan**, the **Dukou Railway** runs from **Panzhihua to Geliping** and is **freight-only**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%B8%A1%E5%8F%A3%E9%93%81%E8%B7%AF)**.

**1971**

* In **1971**, in **Henan**, the **Pingwu Railway** runs from **Wugang to Pingdingshan**, and it is recorded as **both → goods**, with a note that **passenger services were discontinued after 2017**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%B9%B3%E8%88%9E%E9%93%81%E8%B7%AF)**.
* In **1971**, in **Guangxi**, the **Laihe Railway** runs from **Laibin to Heshan**, and it is recorded as **goods → both (from 1999)** with a design speed of **60 km/h**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%9D%A5%E5%90%88%E9%93%81%E8%B7%AF)**.

**1975**

* In **1975**, in **Hebei**, the **Tangzun Railway** runs from **Zunhua to Fengrun** and is **freight-only**. Source: **[Baidu Baike](https://baike.baidu.com/item/%E5%94%90%E9%81%B5%E9%93%81%E8%B7%AF/11032677)**.
* In **1975**, in **Fujian**, the **Yongjia Railway** runs from **Yong’an to Jiafu** and is **freight-only**. Source: **[Baidu Baike1](https://baike.baidu.com/item/%E6%B0%B8%E5%8A%A0%E9%93%81%E8%B7%AF/4096757)/[Baidu Baike2](https://baike.baidu.com/item/%E6%B0%B8%E5%8A%A0%E7%BA%BF/4067721)**.

**1993**

* In **1993**, in **Beijing**, the **Zhouliang Connecting Line** runs from **Zhoukoudian to Liangxiang** and is **freight-only**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%91%A8%E5%8F%A3%E5%BA%97%E9%93%81%E8%B7%AF)**.

**1994**

* In **1994**, in **Hebei**, the **Tangzun Railway** runs from **Fengrun to Tangshan** and is **freight-only**. Source: **[Baidu Baike](https://baike.baidu.com/item/%E5%94%90%E9%81%B5%E9%93%81%E8%B7%AF/11032677)**.

**1996**

* In **1996**, in **Henan**, the **Pingyu Railway** runs from **Pingdingshan to Yuzhou** and is **freight-only**. Sources: **Yearbook / [Wikipedia](https://zh.wikipedia.org/wiki/%E5%B9%B3%E7%A6%B9%E9%90%B5%E8%B7%AF) / [Baidu Baike](https://baike.baidu.com/item/%E5%B9%B3%E7%A6%B9%E9%93%81%E8%B7%AF/5842843)**.

**2001**

* In **2001**, in **Anhui**, the **Qinglu Railway** is a **connecting line between the Qingfu Railway and the Beijing–Shanghai Railway**, serving **Suzhou South** as a **freight-only** line. Source: **China Transportation Yearbook (2002), p.493**.

**2005**

* In **2005**, in **Shanxi**, the **Wuzuo Railway** runs from **Wuxiang to Zuoquan** and is **freight-only**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%AD%A6%E5%B7%A6%E9%93%81%E8%B7%AF)**.

**2012**

* In **2012**, in **Chongqing**, the **Wuhan–Yichang railway** runs from **Wuhan to Yichang**, serves **both passenger and freight**, and has a design speed of **200 km/h**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E6%B1%89%E5%AE%9C%E9%93%81%E8%B7%AF)**.

1. 

2. For the Hanji Railway (邯济铁路), we originally stated that “passenger services ceased after 2015.” Upon verification, the correct information is that passenger services were introduced (i.e., the line began operating passenger services) in 2015.




## Others

### Rail and HSR

**1994**

* In **Hebei**, the **Hanji Railway** runs from **Handan** to **Jinan**. We originally stated that passenger services ceased after **2015**; upon verification, we correct this to passenger services being **introduced in 2015**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E9%82%AF%E6%B5%8E%E9%93%81%E8%B7%AF)**.

**2003**

* In **Jiangxi**, the **Fenwen Railway** runs from **Fenyi** to **Wenzhu**. We originally stated that passenger services were suspended starting in **2007**; upon verification, we correct this to passenger services being discontinued starting in **2003**. Source: **[Baidu](https://baike.baidu.com/item/%E5%88%86%E6%96%87%E9%93%81%E8%B7%AF/153495)**.

**2008**

* In **2008**, in **Anhui**, the **Shanghai–Wuhan–Chengdu passenger-dedicated line (Hefei–Wuhan railway)** runs from **Hefei to Wuhan** as a **passenger line** with a design speed of **250 km/h**. **Problem:** The HSR alignment was already drawn previously, but the year is wrong. **Changes:** Manually erase the **2018** rail layer; change the construction year to **2008**; and set the speed to **250**. Also note that the **Hefei–Wuhan Railway** and the **Hefei–Wuhan High-Speed Railway** are two parallel routes: one is **GT1** and the other is **HSR**; the **2017 HSR** blue line that is already drawn refers to the **Hefei–Wuhan Railway**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%90%88%E6%AD%A6%E9%93%81%E8%B7%AF)**.

**2011**

* In **2011**, in **Guangdong**, the **Guangzhou–Shenzhen–Hong Kong High-Speed Railway** runs from **Guangzhou to Shenzhen** as a **passenger line** with a design speed of **350 km/h**. **Problem:** It was previously drawn, but it was incorrectly connected to the **Wuhan–Guangzhou** line. **Changes:** Separate it from the **Wuhan–Guangzhou** line, and change the construction year to **2011**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%BB%A3%E6%B7%B1%E6%B8%AF%E9%AB%98%E9%80%9F%E9%90%B5%E8%B7%AF)**.

**2015**

* In **2015**, in **Guangxi**, the **Nanning–Kunming high-speed railway** section from **Nanning to Baise** serves **both passenger and freight** with a design speed of **250 km/h**. **Problem:** The line was built in different years but was previously merged into a single segment. **Changes:** Split it into two segments: **2015 Nanning–Baise**, and **2016 Baise–Kunming South Station**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%8D%97%E6%98%86%E5%AE%A2%E8%BF%90%E4%B8%93%E7%BA%BF)**.

**2016**

* In **2016**, in **Guangxi**, the **Nanning–Kunming high-speed railway** section from **Baise to Kunming** serves **both passenger and freight** with a design speed of **250 km/h**. **Problem:** The line was built in different years but was previously merged into a single segment. **Changes:** Split it into two segments: **2015 Nanning–Baise**, and **2016 Baise–Kunming South Station**. Source: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%8D%97%E6%98%86%E5%AE%A2%E8%BF%90%E4%B8%93%E7%BA%BF)**.

**2018**

* In **2018**, in **Shanxi**, the **Datong–Xi’an Passenger Dedicated Line** section from **Taiyuan to Yuanping** is a **passenger line** with a design speed of **350 km/h**. **Problem:** It was previously drawn incorrectly. **Changes:** (1) In **2017_hsr**, delete the **Taiyuan–Yuanping** segment; rename **“Datong–Xi’an Passenger Dedicated Line mixed-traffic section”** to **“Hanyuan Railway”**; and change the speed to **160**. (2) In **2018_hsr**, add the **Taiyuan–Yuanping** segment, named **“Datong–Xi’an Passenger Dedicated Line”**. Sources: **[Wikipedia](https://zh.wikipedia.org/wiki/%E5%A4%A7%E8%A5%BF%E9%AB%98%E9%80%9F%E9%93%81%E8%B7%AF) / China Transportation Yearbook 2019 (p.201)**.



# Summary Statistics of Differences Between the 2017 Old and New Versions

Assuming the old version is **v1.0** and the updated version (with revised roads and algorithms) is **v2.0**, please open the PDF with a PDF viewer (or download it first).
- [Open the PDF](./time_city_diff_analysis.pdf)


