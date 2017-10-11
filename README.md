
Gemma API
=========

[![Build Status](https://travis-ci.org/oganm/gemmaAPI.svg?branch=master)](https://travis-ci.org/oganm/gemmaAPI) [![codecov](https://codecov.io/gh/oganm/gemmaAPI/branch/master/graph/badge.svg)](https://codecov.io/gh/oganm/gemmaAPI)

This is an R wrapper for [Gemma](http://www.chibi.ubc.ca/Gemma/home.html)'s restful [API](http://www.chibi.ubc.ca/Gemma/resources/restapidocs/).

To cite Gemma, please use: [Zoubarev, A., et al., Gemma: A resource for the re-use, sharing and meta-analysis of expression profiling data. Bioinformatics, 2012.](http://dx.doi.org/doi:10.1093/bioinformatics/bts430)

Installation
============

    devtools::install_github('oganm/gemmaAPI')

Documentation
=============

For basic api calls see `?endpointFunctions`. These functions return mostly unaltered data from a given API endpoint.

For high level functions see `?highLevelFunctions`. These functions return data compiled from multiple api calls.

Examples
========

Download data for a dataset

``` r
data = 
    datasetInfo('GSE81454',
                request='data', # we want this endpoint to return data. see documentation
                filter = FALSE, # data request accepts filter argument we want non filtered data
                return = TRUE, # TRUE by default, all functions have this. if false there'll be no return
                file = NULL # NULL by default, all functions have this. If specificed, output will be saved.
    )

head(data) %>% knitr::kable(format ='markdown')
```

<table style="width:100%;">
<colgroup>
<col width="0%" />
<col width="1%" />
<col width="0%" />
<col width="1%" />
<col width="0%" />
<col width="0%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
<col width="3%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Probe</th>
<th align="left">Sequence</th>
<th align="left">GeneSymbol</th>
<th align="left">GeneName</th>
<th align="left">GemmaId</th>
<th align="left">NCBIid</th>
<th align="right">GSE81454_Biomat_16___BioAssayId=414333Name=patient1258.030[38764]</th>
<th align="right">GSE81454_Biomat_17___BioAssayId=414332Name=patient1258.030[38792]</th>
<th align="right">GSE81454_Biomat_19___BioAssayId=414331Name=patient1258.030[38848]</th>
<th align="right">GSE81454_Biomat_3___BioAssayId=414330Name=patient1258.030[39011]</th>
<th align="right">GSE81454_Biomat_1___BioAssayId=414329Name=patient1258.030[39105]</th>
<th align="right">GSE81454_Biomat_29___BioAssayId=414345Name=patient1258.343[39400]</th>
<th align="right">GSE81454_Biomat_5___BioAssayId=414344Name=patient1258.343[39428]</th>
<th align="right">GSE81454_Biomat_2___BioAssayId=414343Name=patient1258.343[39456]</th>
<th align="right">GSE81454_Biomat_9___BioAssayId=414342Name=patient1258.343[39540]</th>
<th align="right">GSE81454_Biomat_7___BioAssayId=414341Name=patient1258.343[39576]</th>
<th align="right">GSE81454_Biomat_18___BioAssayId=414340Name=patient1258.343[39581]</th>
<th align="right">GSE81454_Biomat_20___BioAssayId=414339Name=patient1258.343[39602]</th>
<th align="right">GSE81454_Biomat_21___BioAssayId=414338Name=patient1258.343[39624]</th>
<th align="right">GSE81454_Biomat_22___BioAssayId=414337Name=patient1258.587[39450]</th>
<th align="right">GSE81454_Biomat_24___BioAssayId=414335Name=patient1258.587[39506]</th>
<th align="right">GSE81454_Biomat_23___BioAssayId=414336Name=patient1258.587[39513]</th>
<th align="right">GSE81454_Biomat_25___BioAssayId=414334Name=patient1258.587[39590]</th>
<th align="right">GSE81454_Biomat_4___BioAssayId=414359Name=patient1258.896[39226]</th>
<th align="right">GSE81454_Biomat_6___BioAssayId=414358Name=patient1258.896[39254]</th>
<th align="right">GSE81454_Biomat_8___BioAssayId=414357Name=patient1258.896[39288]</th>
<th align="right">GSE81454_Biomat_10___BioAssayId=414356Name=patient1258.896[39367]</th>
<th align="right">GSE81454_Biomat_11___BioAssayId=414355Name=patient1258.896[39548]</th>
<th align="right">GSE81454_Biomat_12___BioAssayId=414354Name=patient1258.896[39562]</th>
<th align="right">GSE81454_Biomat_13___BioAssayId=414353Name=patient1258.896[39591]</th>
<th align="right">GSE81454_Biomat_14___BioAssayId=414352Name=patient1258.896[39623]</th>
<th align="right">GSE81454_Biomat_15___BioAssayId=414351Name=patient1258.914[39345]</th>
<th align="right">GSE81454_Biomat_26___BioAssayId=414350Name=patient1258.914[39373]</th>
<th align="right">GSE81454_Biomat_27___BioAssayId=414349Name=patient1258.914[39457]</th>
<th align="right">GSE81454_Biomat_30___BioAssayId=414348Name=patient1258.914[39547]</th>
<th align="right">GSE81454_Biomat_31___BioAssayId=414347Name=patient1258.914[39571]</th>
<th align="right">GSE81454_Biomat_28___BioAssayId=414346Name=patient1258.914[39583]</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">11715100_at</td>
<td align="left">11715100_at_collapsed</td>
<td align="left">HIST1H3G</td>
<td align="left">histone cluster 1 H3 family member g</td>
<td align="left">177297</td>
<td align="left">8355</td>
<td align="right">5.570503</td>
<td align="right">5.659476</td>
<td align="right">6.415036</td>
<td align="right">5.034429</td>
<td align="right">5.426796</td>
<td align="right">4.892293</td>
<td align="right">4.487101</td>
<td align="right">5.400989</td>
<td align="right">4.827804</td>
<td align="right">5.033017</td>
<td align="right">5.718246</td>
<td align="right">4.606636</td>
<td align="right">5.112832</td>
<td align="right">4.287139</td>
<td align="right">NaN</td>
<td align="right">5.188428</td>
<td align="right">5.113690</td>
<td align="right">5.457128</td>
<td align="right">5.512145</td>
<td align="right">5.563537</td>
<td align="right">5.945753</td>
<td align="right">5.194899</td>
<td align="right">6.175907</td>
<td align="right">4.784630</td>
<td align="right">6.182247</td>
<td align="right">5.069350</td>
<td align="right">5.833374</td>
<td align="right">5.048324</td>
<td align="right">4.751341</td>
<td align="right">5.432465</td>
<td align="right">5.769437</td>
</tr>
<tr class="even">
<td align="left">11715101_s_at</td>
<td align="left">11715101_s_at_collapsed</td>
<td align="left">HIST1H3G</td>
<td align="left">histone cluster 1 H3 family member g</td>
<td align="left">177297</td>
<td align="left">8355</td>
<td align="right">5.487294</td>
<td align="right">5.853946</td>
<td align="right">5.250355</td>
<td align="right">6.109771</td>
<td align="right">5.865544</td>
<td align="right">5.270979</td>
<td align="right">5.450986</td>
<td align="right">5.891231</td>
<td align="right">5.618118</td>
<td align="right">5.644962</td>
<td align="right">6.278008</td>
<td align="right">5.485405</td>
<td align="right">5.313066</td>
<td align="right">5.452718</td>
<td align="right">NaN</td>
<td align="right">5.922531</td>
<td align="right">5.803046</td>
<td align="right">6.420421</td>
<td align="right">5.627906</td>
<td align="right">5.377154</td>
<td align="right">5.824762</td>
<td align="right">5.380240</td>
<td align="right">5.233704</td>
<td align="right">5.121242</td>
<td align="right">6.178770</td>
<td align="right">5.743275</td>
<td align="right">6.681119</td>
<td align="right">5.611355</td>
<td align="right">6.094411</td>
<td align="right">5.869234</td>
<td align="right">5.840989</td>
</tr>
<tr class="odd">
<td align="left">11715102_x_at</td>
<td align="left">11715102_x_at_collapsed</td>
<td align="left">HIST1H3G</td>
<td align="left">histone cluster 1 H3 family member g</td>
<td align="left">177297</td>
<td align="left">8355</td>
<td align="right">5.257834</td>
<td align="right">5.667169</td>
<td align="right">6.338848</td>
<td align="right">5.432034</td>
<td align="right">5.532680</td>
<td align="right">5.030987</td>
<td align="right">4.772605</td>
<td align="right">5.429676</td>
<td align="right">4.990259</td>
<td align="right">5.389860</td>
<td align="right">5.725368</td>
<td align="right">4.979633</td>
<td align="right">5.133323</td>
<td align="right">4.942821</td>
<td align="right">NaN</td>
<td align="right">5.214772</td>
<td align="right">5.136746</td>
<td align="right">5.728541</td>
<td align="right">5.573771</td>
<td align="right">5.383527</td>
<td align="right">5.718765</td>
<td align="right">5.148762</td>
<td align="right">5.741534</td>
<td align="right">4.936318</td>
<td align="right">6.366660</td>
<td align="right">5.099642</td>
<td align="right">5.727999</td>
<td align="right">5.288398</td>
<td align="right">5.410846</td>
<td align="right">5.514827</td>
<td align="right">5.355642</td>
</tr>
<tr class="even">
<td align="left">11715103_x_at</td>
<td align="left">11715103_x_at_collapsed</td>
<td align="left">TNFAIP8L1</td>
<td align="left">TNF alpha induced protein 8 like 1</td>
<td align="left">383466</td>
<td align="left">126282</td>
<td align="right">6.953158</td>
<td align="right">6.858097</td>
<td align="right">7.447029</td>
<td align="right">6.388124</td>
<td align="right">6.063064</td>
<td align="right">6.321904</td>
<td align="right">6.340300</td>
<td align="right">6.123329</td>
<td align="right">6.317084</td>
<td align="right">6.025254</td>
<td align="right">6.367156</td>
<td align="right">6.799037</td>
<td align="right">7.040401</td>
<td align="right">6.557198</td>
<td align="right">NaN</td>
<td align="right">6.629878</td>
<td align="right">6.977430</td>
<td align="right">6.750851</td>
<td align="right">7.408168</td>
<td align="right">7.359081</td>
<td align="right">7.244597</td>
<td align="right">7.321723</td>
<td align="right">6.984844</td>
<td align="right">6.461715</td>
<td align="right">6.555690</td>
<td align="right">6.316880</td>
<td align="right">6.925883</td>
<td align="right">6.809245</td>
<td align="right">5.967934</td>
<td align="right">7.223364</td>
<td align="right">6.474017</td>
</tr>
<tr class="odd">
<td align="left">11715104_s_at</td>
<td align="left">11715104_s_at_collapsed</td>
<td align="left">OTOP2</td>
<td align="left">otopetrin 2</td>
<td align="left">371285</td>
<td align="left">92736</td>
<td align="right">4.898549</td>
<td align="right">4.879274</td>
<td align="right">4.988879</td>
<td align="right">5.134439</td>
<td align="right">5.227622</td>
<td align="right">4.634448</td>
<td align="right">4.651539</td>
<td align="right">4.816147</td>
<td align="right">4.845465</td>
<td align="right">4.830638</td>
<td align="right">5.405226</td>
<td align="right">4.545178</td>
<td align="right">4.988664</td>
<td align="right">4.561036</td>
<td align="right">NaN</td>
<td align="right">4.920630</td>
<td align="right">4.889482</td>
<td align="right">5.125845</td>
<td align="right">4.781876</td>
<td align="right">4.601714</td>
<td align="right">5.121119</td>
<td align="right">4.699846</td>
<td align="right">5.013212</td>
<td align="right">4.465212</td>
<td align="right">5.929242</td>
<td align="right">4.788102</td>
<td align="right">5.499493</td>
<td align="right">4.703555</td>
<td align="right">4.757666</td>
<td align="right">5.626993</td>
<td align="right">5.355086</td>
</tr>
<tr class="even">
<td align="left">11715105_at</td>
<td align="left">11715105_at_collapsed</td>
<td align="left">C17orf78</td>
<td align="left">chromosome 17 open reading frame 78</td>
<td align="left">418711</td>
<td align="left">284099</td>
<td align="right">3.847085</td>
<td align="right">4.127623</td>
<td align="right">3.769223</td>
<td align="right">4.081084</td>
<td align="right">3.814237</td>
<td align="right">3.823463</td>
<td align="right">4.129402</td>
<td align="right">4.070782</td>
<td align="right">3.997425</td>
<td align="right">4.061624</td>
<td align="right">4.311170</td>
<td align="right">3.711516</td>
<td align="right">4.088457</td>
<td align="right">3.856652</td>
<td align="right">NaN</td>
<td align="right">3.873692</td>
<td align="right">3.956026</td>
<td align="right">4.035804</td>
<td align="right">4.312054</td>
<td align="right">4.256968</td>
<td align="right">3.942893</td>
<td align="right">3.860630</td>
<td align="right">3.864055</td>
<td align="right">3.881321</td>
<td align="right">4.236889</td>
<td align="right">4.029763</td>
<td align="right">4.506718</td>
<td align="right">3.996703</td>
<td align="right">3.849092</td>
<td align="right">4.211920</td>
<td align="right">4.313114</td>
</tr>
</tbody>
</table>
