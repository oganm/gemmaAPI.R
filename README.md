
Gemma API <img src="gemmaAPI.png" align="right" height="100px"/>
================================================================

[![Build Status](https://travis-ci.org/PavlidisLab/gemmaAPI.R.svg?branch=master)](https://travis-ci.org/PavlidisLab/gemmaAPI.R)[![codecov](https://codecov.io/gh/PavlidisLab/gemmaAPI.R/branch/master/graph/badge.svg)](https://codecov.io/gh/PavlidisLab/gemmaAPI.R)

Table of Contents
=================

-   [Installation](#installation)
-   [Documentation](#documentation)
-   [Examples](#examples)
-   [Changelog](#changelog)

This is an R wrapper for [Gemma](http://www.chibi.ubc.ca/Gemma/home.html)'s restful [API](http://www.chibi.ubc.ca/Gemma/resources/restapidocs/).

To cite Gemma, please use: [Zoubarev, A., et al., Gemma: A resource for the re-use, sharing and meta-analysis of expression profiling data. Bioinformatics, 2012.](http://dx.doi.org/doi:10.1093/bioinformatics/bts430)

Installation
============

    devtools::install_github('PavlidisLab/gemmaAPI.R')

Documentation
=============

For basic api calls see `?endpointFunctions`. These functions return mostly unaltered data from a given API endpoint.

For high level functions see `?highLevelFunctions`. These functions return data compiled from multiple api calls.

Examples
========

Download data for a dataset

``` r
data = 
    datasetInfo('GSE107999',
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
<col width="1%" />
<col width="7%" />
<col width="1%" />
<col width="1%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
<col width="7%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Probe</th>
<th align="left">Sequence</th>
<th align="left">GeneSymbol</th>
<th align="left">GeneName</th>
<th align="left">GemmaId</th>
<th align="left">NCBIid</th>
<th align="right">GSE107999_Biomat_9___BioAssayId=427205Name=LUHMEScells,untreated,proliferatingprecursorstaterep4</th>
<th align="right">GSE107999_Biomat_8___BioAssayId=427206Name=LUHMEScells,untreated,proliferatingprecursorstaterep3</th>
<th align="right">GSE107999_Biomat_12___BioAssayId=427207Name=LUHMEScells,untreated,proliferatingprecursorstaterep2</th>
<th align="right">GSE107999_Biomat_10___BioAssayId=427208Name=LUHMEScells,untreated,proliferatingprecursorstaterep1</th>
<th align="right">GSE107999_Biomat_5___BioAssayId=427201Name=LUHMEScells,untreated,day3ofdifferentiationrep4</th>
<th align="right">GSE107999_Biomat_4___BioAssayId=427202Name=LUHMEScells,untreated,day3ofdifferentiationrep3</th>
<th align="right">GSE107999_Biomat_7___BioAssayId=427203Name=LUHMEScells,untreated,day3ofdifferentiationrep2</th>
<th align="right">GSE107999_Biomat_6___BioAssayId=427204Name=LUHMEScells,untreated,day3ofdifferentiationrep1</th>
<th align="right">GSE107999_Biomat_11___BioAssayId=427197Name=LUHMEScells,untreated,day6ofdifferentiationrep4</th>
<th align="right">GSE107999_Biomat_2___BioAssayId=427198Name=LUHMEScells,untreated,day6ofdifferentiationrep3</th>
<th align="right">GSE107999_Biomat_1___BioAssayId=427199Name=LUHMEScells,untreated,day6ofdifferentiationrep2</th>
<th align="right">GSE107999_Biomat_3___BioAssayId=427200Name=LUHMEScells,untreated,day6ofdifferentiationrep1</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">1007_s_at</td>
<td align="left">1007_s_at_collapsed</td>
<td align="left">DDR1</td>
<td align="left">discoidin domain receptor tyrosine kinase 1</td>
<td align="left">16908</td>
<td align="left">780</td>
<td align="right">8.360044</td>
<td align="right">8.347570</td>
<td align="right">8.384220</td>
<td align="right">8.631552</td>
<td align="right">9.426037</td>
<td align="right">9.332862</td>
<td align="right">9.556137</td>
<td align="right">9.571225</td>
<td align="right">9.830016</td>
<td align="right">9.534368</td>
<td align="right">9.644813</td>
<td align="right">9.638160</td>
</tr>
<tr class="even">
<td align="left">1053_at</td>
<td align="left">1053_at_collapsed</td>
<td align="left">RFC2</td>
<td align="left">replication factor C subunit 2</td>
<td align="left">139878</td>
<td align="left">5982</td>
<td align="right">8.321700</td>
<td align="right">8.441607</td>
<td align="right">8.538243</td>
<td align="right">8.223463</td>
<td align="right">6.900833</td>
<td align="right">7.811239</td>
<td align="right">7.362803</td>
<td align="right">7.487110</td>
<td align="right">6.727149</td>
<td align="right">6.781015</td>
<td align="right">6.871821</td>
<td align="right">6.822983</td>
</tr>
<tr class="odd">
<td align="left">117_at</td>
<td align="left">117_at_collapsed</td>
<td align="left">HSPA7|HSPA6</td>
<td align="left">heat shock protein family A (Hsp70) member 7|heat shock protein family A (Hsp70) member 6</td>
<td align="left">73442|73420</td>
<td align="left">3311|3310</td>
<td align="right">5.640347</td>
<td align="right">4.309247</td>
<td align="right">4.561608</td>
<td align="right">4.412733</td>
<td align="right">4.274228</td>
<td align="right">4.109736</td>
<td align="right">4.466428</td>
<td align="right">4.262011</td>
<td align="right">4.013711</td>
<td align="right">4.285905</td>
<td align="right">4.445415</td>
<td align="right">3.929470</td>
</tr>
<tr class="even">
<td align="left">121_at</td>
<td align="left">121_at_collapsed</td>
<td align="left">PAX8</td>
<td align="left">paired box 8</td>
<td align="left">173107</td>
<td align="left">7849</td>
<td align="right">6.915072</td>
<td align="right">7.001704</td>
<td align="right">6.886536</td>
<td align="right">6.995852</td>
<td align="right">6.789746</td>
<td align="right">6.988139</td>
<td align="right">6.950670</td>
<td align="right">6.897583</td>
<td align="right">6.632473</td>
<td align="right">6.872863</td>
<td align="right">6.892053</td>
<td align="right">6.845294</td>
</tr>
<tr class="odd">
<td align="left">1255_g_at</td>
<td align="left">1255_g_at_collapsed</td>
<td align="left">GUCA1A</td>
<td align="left">guanylate cyclase activator 1A</td>
<td align="left">58787</td>
<td align="left">2978</td>
<td align="right">2.328086</td>
<td align="right">2.683368</td>
<td align="right">2.292127</td>
<td align="right">2.395157</td>
<td align="right">2.267915</td>
<td align="right">2.371985</td>
<td align="right">2.148122</td>
<td align="right">2.219700</td>
<td align="right">2.078340</td>
<td align="right">2.243999</td>
<td align="right">2.376379</td>
<td align="right">2.238994</td>
</tr>
<tr class="even">
<td align="left">1294_at</td>
<td align="left">1294_at_collapsed</td>
<td align="left">UBA7</td>
<td align="left">ubiquitin like modifier activating enzyme 7</td>
<td align="left">165857</td>
<td align="left">7318</td>
<td align="right">4.436209</td>
<td align="right">4.315595</td>
<td align="right">4.434729</td>
<td align="right">4.505724</td>
<td align="right">4.182772</td>
<td align="right">4.334539</td>
<td align="right">4.278525</td>
<td align="right">4.204030</td>
<td align="right">4.105466</td>
<td align="right">4.410392</td>
<td align="right">4.382536</td>
<td align="right">4.151413</td>
</tr>
</tbody>
</table>

Get metadata for first 10 mouse studies.

``` r
mouseStudies = taxonInfo('mouse',request = 'datasets',limit = 0)
studyIDs = mouseStudies %>% purrr::map_int('id')
mouseMetadata = studyIDs[1:10] %>% lapply(compileMetadata,outputType = 'list') 
# default outputType is data.frame, which returns a single data frame with study and sample data all together.
mouseMetadata[[1]]$sampleData %>% head %>% knitr::kable(format ='markdown')
```

<table>
<colgroup>
<col width="6%" />
<col width="0%" />
<col width="6%" />
<col width="1%" />
<col width="2%" />
<col width="2%" />
<col width="3%" />
<col width="10%" />
<col width="3%" />
<col width="4%" />
<col width="5%" />
<col width="15%" />
<col width="3%" />
<col width="2%" />
<col width="12%" />
<col width="19%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"></th>
<th align="left">id</th>
<th align="left">sampleName</th>
<th align="left">accession</th>
<th align="right">sampleBiomaterialID</th>
<th align="left">sampleAnnotCategory</th>
<th align="left">sampleAnnotCategoryOntoID</th>
<th align="left">sampleAnnotCategoryURI</th>
<th align="left">sampleAnnotBroadCategory</th>
<th align="left">sampleAnnotBroadCategoryOntoID</th>
<th align="left">sampleAnnotBroadCategoryURI</th>
<th align="left">sampleAnnotation</th>
<th align="left">sampleAnnotationOntoID</th>
<th align="left">sampleAnnotType</th>
<th align="left">sampleAnnotationURI</th>
<th align="left">otherCharacteristics</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Brain_C57 Wildtype_affs275-1099</td>
<td align="left">48</td>
<td align="left">Brain_C57 Wildtype_affs275-1099</td>
<td align="left">GSM101416</td>
<td align="right">48</td>
<td align="left">genotype</td>
<td align="left">EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">genotype</td>
<td align="left">EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">wild type genotype</td>
<td align="left">EFO_0005168</td>
<td align="left">factor</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0005168" class="uri">http://www.ebi.ac.uk/efo/EFO_0005168</a></td>
<td align="left">total RNA|Biotin|C57 Wildtype Mouse #1099 Brain|Strain: C57BL/6 Gender: female Age: 123 days Tissue: brain</td>
</tr>
<tr class="even">
<td align="left">Brain_C57 Wildtype_affs275-1100</td>
<td align="left">47</td>
<td align="left">Brain_C57 Wildtype_affs275-1100</td>
<td align="left">GSM101417</td>
<td align="right">47</td>
<td align="left">genotype</td>
<td align="left">EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">genotype</td>
<td align="left">EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">wild type genotype</td>
<td align="left">EFO_0005168</td>
<td align="left">factor</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0005168" class="uri">http://www.ebi.ac.uk/efo/EFO_0005168</a></td>
<td align="left">total RNA|C57 Wildtype Mouse #1100 Brain|Biotin|Strain: C57BL/6 Gender: female Age: 123 days Tissue: brain</td>
</tr>
<tr class="odd">
<td align="left">Brain_Melanotransferrin Knockout_affs275-1096</td>
<td align="left">52</td>
<td align="left">Brain_Melanotransferrin Knockout_affs275-1096</td>
<td align="left">GSM101412</td>
<td align="right">52</td>
<td align="left">genotype;genotype</td>
<td align="left">EFO_0000513;EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513;http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513;http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">genotype</td>
<td align="left">EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">Homozygous negative;Mfi2 [mouse] antigen p97 (melanoma associated) identified by monoclonal antibodies 133.2 and 96.5</td>
<td align="left">TGEMO_00001;GENE_30060</td>
<td align="left">factor</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00001;http://purl.org/commons/record/ncbi_gene/30060" class="uri">http://purl.obolibrary.org/obo/TGEMO_00001;http://purl.org/commons/record/ncbi_gene/30060</a></td>
<td align="left">total RNA|brain|Melanotransferrin Knockout Mouse #1096 Brain|female|Biotin|Strain: C57BL/6 - Lucy|Age: 123 days</td>
</tr>
<tr class="even">
<td align="left">Brain_Melanotransferrin Knockout_affs275-1097</td>
<td align="left">51</td>
<td align="left">Brain_Melanotransferrin Knockout_affs275-1097</td>
<td align="left">GSM101413</td>
<td align="right">51</td>
<td align="left">genotype;genotype</td>
<td align="left">EFO_0000513;EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513;http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513;http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">genotype</td>
<td align="left">EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">Homozygous negative;Mfi2 [mouse] antigen p97 (melanoma associated) identified by monoclonal antibodies 133.2 and 96.5</td>
<td align="left">TGEMO_00001;GENE_30060</td>
<td align="left">factor</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00001;http://purl.org/commons/record/ncbi_gene/30060" class="uri">http://purl.obolibrary.org/obo/TGEMO_00001;http://purl.org/commons/record/ncbi_gene/30060</a></td>
<td align="left">total RNA|Melanotransferrin Knockout Mouse #1097 Brain|Biotin|Strain: C57BL/6 - Lucy Gender: female Age: 123 days Tissue: brain</td>
</tr>
<tr class="odd">
<td align="left">Brain_Melanotransferrin Knockout_affs275-1098</td>
<td align="left">50</td>
<td align="left">Brain_Melanotransferrin Knockout_affs275-1098</td>
<td align="left">GSM101414</td>
<td align="right">50</td>
<td align="left">genotype;genotype</td>
<td align="left">EFO_0000513;EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513;http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513;http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">genotype</td>
<td align="left">EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">Homozygous negative;Mfi2 [mouse] antigen p97 (melanoma associated) identified by monoclonal antibodies 133.2 and 96.5</td>
<td align="left">TGEMO_00001;GENE_30060</td>
<td align="left">factor</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00001;http://purl.org/commons/record/ncbi_gene/30060" class="uri">http://purl.obolibrary.org/obo/TGEMO_00001;http://purl.org/commons/record/ncbi_gene/30060</a></td>
<td align="left">total RNA|Biotin|Melanotransferrin Knockout Mouse #1098 Brain|Strain: C57BL/6 - Lucy Gender: female Age: 123 days Tissue: brain</td>
</tr>
<tr class="even">
<td align="left">Brain_Melanotransferrin Knockout_affs275-1101</td>
<td align="left">49</td>
<td align="left">Brain_Melanotransferrin Knockout_affs275-1101</td>
<td align="left">GSM101415</td>
<td align="right">49</td>
<td align="left">genotype;genotype</td>
<td align="left">EFO_0000513;EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513;http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513;http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">genotype</td>
<td align="left">EFO_0000513</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0000513" class="uri">http://www.ebi.ac.uk/efo/EFO_0000513</a></td>
<td align="left">Homozygous negative;Mfi2 [mouse] antigen p97 (melanoma associated) identified by monoclonal antibodies 133.2 and 96.5</td>
<td align="left">TGEMO_00001;GENE_30060</td>
<td align="left">factor</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00001;http://purl.org/commons/record/ncbi_gene/30060" class="uri">http://purl.obolibrary.org/obo/TGEMO_00001;http://purl.org/commons/record/ncbi_gene/30060</a></td>
<td align="left">Melanotransferrin Knockout Mouse #1101 Brain|total RNA|Biotin|Strain: C57BL/6 - Lucy Gender: female Age: 123 days Tissue: brain</td>
</tr>
</tbody>
</table>

Download expression data a study

``` r
studyIDs %>% sapply(function(x){datasetInfo(x,request= 'data',return= FALSE, file = paste0('data/',x))})
```

Changelog
=========

**17 September 2018:**

-   Start writing changelog...
-   `compileMetadata` function now returns all quality information in geeq. Existing columnames for batch effect information has been altered to better explain what they are.
-   `compileMetadata` now returns a list instead of a data frame for experiment specific information if the desired output is a list.
-   endpoint functions are fine if their naming variable is NULL. For most cases this shouldn't happen but names are for interactive usage and should not be relied on.
-   Started using proper semantic versioning
-   TOC added to readme
