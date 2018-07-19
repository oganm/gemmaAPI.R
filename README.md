
Gemma API <img src="gemmaAPI.png" align="right" height="100px"/>
================================================================

[![Build Status](https://travis-ci.org/PavlidisLab/gemmaAPI.R.svg?branch=master)](https://travis-ci.org/PavlidisLab/gemmaAPI.R)[![codecov](https://codecov.io/gh/PavlidisLab/gemmaAPI.R/branch/master/graph/badge.svg)](https://codecov.io/gh/PavlidisLab/gemmaAPI.R)

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
```

    ## Parsed with column specification:
    ## cols(
    ##   Probe = col_character(),
    ##   Sequence = col_character(),
    ##   GeneSymbol = col_character(),
    ##   GeneName = col_character(),
    ##   GemmaId = col_character(),
    ##   NCBIid = col_character(),
    ##   `GSE107999_Biomat_9___BioAssayId=427205Name=LUHMEScells,untreated,proliferatingprecursorstaterep4` = col_double(),
    ##   `GSE107999_Biomat_8___BioAssayId=427206Name=LUHMEScells,untreated,proliferatingprecursorstaterep3` = col_double(),
    ##   `GSE107999_Biomat_12___BioAssayId=427207Name=LUHMEScells,untreated,proliferatingprecursorstaterep2` = col_double(),
    ##   `GSE107999_Biomat_10___BioAssayId=427208Name=LUHMEScells,untreated,proliferatingprecursorstaterep1` = col_double(),
    ##   `GSE107999_Biomat_5___BioAssayId=427201Name=LUHMEScells,untreated,day3ofdifferentiationrep4` = col_double(),
    ##   `GSE107999_Biomat_4___BioAssayId=427202Name=LUHMEScells,untreated,day3ofdifferentiationrep3` = col_double(),
    ##   `GSE107999_Biomat_7___BioAssayId=427203Name=LUHMEScells,untreated,day3ofdifferentiationrep2` = col_double(),
    ##   `GSE107999_Biomat_6___BioAssayId=427204Name=LUHMEScells,untreated,day3ofdifferentiationrep1` = col_double(),
    ##   `GSE107999_Biomat_11___BioAssayId=427197Name=LUHMEScells,untreated,day6ofdifferentiationrep4` = col_double(),
    ##   `GSE107999_Biomat_2___BioAssayId=427198Name=LUHMEScells,untreated,day6ofdifferentiationrep3` = col_double(),
    ##   `GSE107999_Biomat_1___BioAssayId=427199Name=LUHMEScells,untreated,day6ofdifferentiationrep2` = col_double(),
    ##   `GSE107999_Biomat_3___BioAssayId=427200Name=LUHMEScells,untreated,day6ofdifferentiationrep1` = col_double()
    ## )

``` r
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
mouseMetadata = studyIDs[1:10] %>% lapply(compileMetadata)
mouseMetadata[[1]] %>% head %>% knitr::kable(format ='markdown')
```

<table>
<colgroup>
<col width="4%" />
<col width="0%" />
<col width="1%" />
<col width="0%" />
<col width="3%" />
<col width="4%" />
<col width="11%" />
<col width="2%" />
<col width="4%" />
<col width="12%" />
<col width="1%" />
<col width="1%" />
<col width="1%" />
<col width="0%" />
<col width="1%" />
<col width="0%" />
<col width="1%" />
<col width="0%" />
<col width="4%" />
<col width="0%" />
<col width="1%" />
<col width="1%" />
<col width="2%" />
<col width="6%" />
<col width="2%" />
<col width="2%" />
<col width="3%" />
<col width="10%" />
<col width="2%" />
<col width="1%" />
<col width="7%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"></th>
<th align="right">datasetID</th>
<th align="left">datasetName</th>
<th align="left">taxon</th>
<th align="left">experimentAnnotClass</th>
<th align="left">experimentAnnotClassOntoID</th>
<th align="left">experimentAnnotClassURI</th>
<th align="left">experimentAnnotation</th>
<th align="left">experimentAnnotationOntoID</th>
<th align="left">experimentAnnotationURI</th>
<th align="left">platformName</th>
<th align="left">technologyType</th>
<th align="right">batchConfound</th>
<th align="left">batchConf</th>
<th align="right">batchEffect</th>
<th align="left">batchEf</th>
<th align="left">batchCorrected</th>
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
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Brain_C57 Wildtype_affs275-1099</td>
<td align="right">3</td>
<td align="left">GSE4523</td>
<td align="left">mouse</td>
<td align="left">strain|organism part|sex</td>
<td align="left">EFO_0005135|EFO_0000635|PATO_0000047</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0005135%7Chttp://www.ebi.ac.uk/efo/EFO_0000635%7Chttp://purl.obolibrary.org/obo/PATO_0000047" class="uri">http://www.ebi.ac.uk/efo/EFO_0005135|http://www.ebi.ac.uk/efo/EFO_0000635|http://purl.obolibrary.org/obo/PATO_0000047</a></td>
<td align="left">C57BL/6|brain|female</td>
<td align="left">TGEMO_00016|UBERON_0000955|PATO_0000383</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00016%7Chttp://purl.obolibrary.org/obo/UBERON_0000955%7Chttp://purl.obolibrary.org/obo/PATO_0000383" class="uri">http://purl.obolibrary.org/obo/TGEMO_00016|http://purl.obolibrary.org/obo/UBERON_0000955|http://purl.obolibrary.org/obo/PATO_0000383</a></td>
<td align="left">GPL1261</td>
<td align="left">ONECOLOR</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="left">FALSE</td>
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
</tr>
<tr class="even">
<td align="left">Brain_C57 Wildtype_affs275-1100</td>
<td align="right">3</td>
<td align="left">GSE4523</td>
<td align="left">mouse</td>
<td align="left">strain|organism part|sex</td>
<td align="left">EFO_0005135|EFO_0000635|PATO_0000047</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0005135%7Chttp://www.ebi.ac.uk/efo/EFO_0000635%7Chttp://purl.obolibrary.org/obo/PATO_0000047" class="uri">http://www.ebi.ac.uk/efo/EFO_0005135|http://www.ebi.ac.uk/efo/EFO_0000635|http://purl.obolibrary.org/obo/PATO_0000047</a></td>
<td align="left">C57BL/6|brain|female</td>
<td align="left">TGEMO_00016|UBERON_0000955|PATO_0000383</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00016%7Chttp://purl.obolibrary.org/obo/UBERON_0000955%7Chttp://purl.obolibrary.org/obo/PATO_0000383" class="uri">http://purl.obolibrary.org/obo/TGEMO_00016|http://purl.obolibrary.org/obo/UBERON_0000955|http://purl.obolibrary.org/obo/PATO_0000383</a></td>
<td align="left">GPL1261</td>
<td align="left">ONECOLOR</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="left">FALSE</td>
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
</tr>
<tr class="odd">
<td align="left">Brain_Melanotransferrin Knockout_affs275-1096</td>
<td align="right">3</td>
<td align="left">GSE4523</td>
<td align="left">mouse</td>
<td align="left">strain|organism part|sex</td>
<td align="left">EFO_0005135|EFO_0000635|PATO_0000047</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0005135%7Chttp://www.ebi.ac.uk/efo/EFO_0000635%7Chttp://purl.obolibrary.org/obo/PATO_0000047" class="uri">http://www.ebi.ac.uk/efo/EFO_0005135|http://www.ebi.ac.uk/efo/EFO_0000635|http://purl.obolibrary.org/obo/PATO_0000047</a></td>
<td align="left">C57BL/6|brain|female</td>
<td align="left">TGEMO_00016|UBERON_0000955|PATO_0000383</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00016%7Chttp://purl.obolibrary.org/obo/UBERON_0000955%7Chttp://purl.obolibrary.org/obo/PATO_0000383" class="uri">http://purl.obolibrary.org/obo/TGEMO_00016|http://purl.obolibrary.org/obo/UBERON_0000955|http://purl.obolibrary.org/obo/PATO_0000383</a></td>
<td align="left">GPL1261</td>
<td align="left">ONECOLOR</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="left">FALSE</td>
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
<td align="left">Mfi2 [mouse] antigen p97 (melanoma associated) identified by monoclonal antibodies 133.2 and 96.5;Homozygous negative</td>
<td align="left">GENE_30060;TGEMO_00001</td>
<td align="left">factor</td>
<td align="left"><a href="http://purl.org/commons/record/ncbi_gene/30060;http://purl.obolibrary.org/obo/TGEMO_00001" class="uri">http://purl.org/commons/record/ncbi_gene/30060;http://purl.obolibrary.org/obo/TGEMO_00001</a></td>
</tr>
<tr class="even">
<td align="left">Brain_Melanotransferrin Knockout_affs275-1097</td>
<td align="right">3</td>
<td align="left">GSE4523</td>
<td align="left">mouse</td>
<td align="left">strain|organism part|sex</td>
<td align="left">EFO_0005135|EFO_0000635|PATO_0000047</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0005135%7Chttp://www.ebi.ac.uk/efo/EFO_0000635%7Chttp://purl.obolibrary.org/obo/PATO_0000047" class="uri">http://www.ebi.ac.uk/efo/EFO_0005135|http://www.ebi.ac.uk/efo/EFO_0000635|http://purl.obolibrary.org/obo/PATO_0000047</a></td>
<td align="left">C57BL/6|brain|female</td>
<td align="left">TGEMO_00016|UBERON_0000955|PATO_0000383</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00016%7Chttp://purl.obolibrary.org/obo/UBERON_0000955%7Chttp://purl.obolibrary.org/obo/PATO_0000383" class="uri">http://purl.obolibrary.org/obo/TGEMO_00016|http://purl.obolibrary.org/obo/UBERON_0000955|http://purl.obolibrary.org/obo/PATO_0000383</a></td>
<td align="left">GPL1261</td>
<td align="left">ONECOLOR</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="left">FALSE</td>
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
<td align="left">Mfi2 [mouse] antigen p97 (melanoma associated) identified by monoclonal antibodies 133.2 and 96.5;Homozygous negative</td>
<td align="left">GENE_30060;TGEMO_00001</td>
<td align="left">factor</td>
<td align="left"><a href="http://purl.org/commons/record/ncbi_gene/30060;http://purl.obolibrary.org/obo/TGEMO_00001" class="uri">http://purl.org/commons/record/ncbi_gene/30060;http://purl.obolibrary.org/obo/TGEMO_00001</a></td>
</tr>
<tr class="odd">
<td align="left">Brain_Melanotransferrin Knockout_affs275-1098</td>
<td align="right">3</td>
<td align="left">GSE4523</td>
<td align="left">mouse</td>
<td align="left">strain|organism part|sex</td>
<td align="left">EFO_0005135|EFO_0000635|PATO_0000047</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0005135%7Chttp://www.ebi.ac.uk/efo/EFO_0000635%7Chttp://purl.obolibrary.org/obo/PATO_0000047" class="uri">http://www.ebi.ac.uk/efo/EFO_0005135|http://www.ebi.ac.uk/efo/EFO_0000635|http://purl.obolibrary.org/obo/PATO_0000047</a></td>
<td align="left">C57BL/6|brain|female</td>
<td align="left">TGEMO_00016|UBERON_0000955|PATO_0000383</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00016%7Chttp://purl.obolibrary.org/obo/UBERON_0000955%7Chttp://purl.obolibrary.org/obo/PATO_0000383" class="uri">http://purl.obolibrary.org/obo/TGEMO_00016|http://purl.obolibrary.org/obo/UBERON_0000955|http://purl.obolibrary.org/obo/PATO_0000383</a></td>
<td align="left">GPL1261</td>
<td align="left">ONECOLOR</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="left">FALSE</td>
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
<td align="left">Mfi2 [mouse] antigen p97 (melanoma associated) identified by monoclonal antibodies 133.2 and 96.5;Homozygous negative</td>
<td align="left">GENE_30060;TGEMO_00001</td>
<td align="left">factor</td>
<td align="left"><a href="http://purl.org/commons/record/ncbi_gene/30060;http://purl.obolibrary.org/obo/TGEMO_00001" class="uri">http://purl.org/commons/record/ncbi_gene/30060;http://purl.obolibrary.org/obo/TGEMO_00001</a></td>
</tr>
<tr class="even">
<td align="left">Brain_Melanotransferrin Knockout_affs275-1101</td>
<td align="right">3</td>
<td align="left">GSE4523</td>
<td align="left">mouse</td>
<td align="left">strain|organism part|sex</td>
<td align="left">EFO_0005135|EFO_0000635|PATO_0000047</td>
<td align="left"><a href="http://www.ebi.ac.uk/efo/EFO_0005135%7Chttp://www.ebi.ac.uk/efo/EFO_0000635%7Chttp://purl.obolibrary.org/obo/PATO_0000047" class="uri">http://www.ebi.ac.uk/efo/EFO_0005135|http://www.ebi.ac.uk/efo/EFO_0000635|http://purl.obolibrary.org/obo/PATO_0000047</a></td>
<td align="left">C57BL/6|brain|female</td>
<td align="left">TGEMO_00016|UBERON_0000955|PATO_0000383</td>
<td align="left"><a href="http://purl.obolibrary.org/obo/TGEMO_00016%7Chttp://purl.obolibrary.org/obo/UBERON_0000955%7Chttp://purl.obolibrary.org/obo/PATO_0000383" class="uri">http://purl.obolibrary.org/obo/TGEMO_00016|http://purl.obolibrary.org/obo/UBERON_0000955|http://purl.obolibrary.org/obo/PATO_0000383</a></td>
<td align="left">GPL1261</td>
<td align="left">ONECOLOR</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="right">0</td>
<td align="left">NA</td>
<td align="left">FALSE</td>
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
<td align="left">Mfi2 [mouse] antigen p97 (melanoma associated) identified by monoclonal antibodies 133.2 and 96.5;Homozygous negative</td>
<td align="left">GENE_30060;TGEMO_00001</td>
<td align="left">factor</td>
<td align="left"><a href="http://purl.org/commons/record/ncbi_gene/30060;http://purl.obolibrary.org/obo/TGEMO_00001" class="uri">http://purl.org/commons/record/ncbi_gene/30060;http://purl.obolibrary.org/obo/TGEMO_00001</a></td>
</tr>
</tbody>
</table>

Download expression data a study

``` r
studyIDs %>% sapply(function(x){datasetInfo(x,request= 'data',return= FALSE, file = paste0('data/',x))})
```
