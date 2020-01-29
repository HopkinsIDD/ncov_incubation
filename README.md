Real-time estimation of the Wuhan coronavirus incubation time
=============================================================

Updated: Wed Jan 29 00:28:41 2020

Our lab has been collecting data (freely available at
[`data/nCoV-IDD-traveler-data.csv`](https://github.com/HopkinsIDD/ncov_incubation/blob/master/data/nCoV-IDD-traveler-data.csv))
on the exposure and symptom onset for Wuhan novel coronavirus
(nCoV-2019) cases that have been confirmed outside of the Hubei
province. These cases have been confirmed either in other countries or
in regions of China with no known local transmission. We search for news
articles and reports in both English and Chinese and abstract the data
necessary to estimate the incubation period of nCoV-2019. Two team
members independently review the full text of each case report to ensure
that data is correctly input. Discrepancies are resolved by discussion
and consensus.

Data summary
------------

There are 101 cases that have been double-checked by our team. Of those
34 are known to be female (34%) and 63 are male (62%). The median age is
about 51.5 years (IQR: 36.25-57.5). 30 cases are from Mainland China
(30%), while 71 are from the rest of the world (70%). 61 cases presented
with a fever (60%).

Exposure and symptom onset windows
----------------------------------

The necessary components for estimating the incubation period are left
and right bounds for the exposure (EL and ER) and symptom onset times
(SE and SR) for each case. We use explicit dates and times when they are
reported in the source documents, however when they are not available,
we make the following assumptions:

-   For cases without a reported right-bound on symptom onset time (SR),
    we use the time that the case is first presented to a hospital or,
    lacking that, the time that the source document was published
-   For cases without an EL, we use 2019 December 1, which was the onset
    date for the first reported nCoV-2019 case; though we will test this
    assumption later
-   For cases without an ER, we use the SR
-   For cases without an SL, we use the EL

Under these assumptions, the median exposure interval was 49 (range:
1-58.8) and the median symptom onset interval was 1 (range: 0-58.8).

<img src="README_files/figure-markdown_strict/data-summary-1.png" alt="This figure displays the exposure and symptom onset windows for each case in our dataset, relative to the right-bound of the exposure window (ER). The blue bars indicate the the exposure windows and the red bars indicate the symptom onset windows for each case. Purple areas are where those two bars overlap."  />
<p class="caption">
This figure displays the exposure and symptom onset windows for each
case in our dataset, relative to the right-bound of the exposure window
(ER). The blue bars indicate the the exposure windows and the red bars
indicate the symptom onset windows for each case. Purple areas are where
those two bars overlap.
</p>

Incubation period estimates
---------------------------

We estimate the incubation period using the coarseDataTools package
based on the paper by [Reich *et al*,
2009](https://onlinelibrary.wiley.com/doi/pdf/10.1002/sim.3659). We
assume a log-normal incubation period and using a bootstrap method for
calculating confidence intervals.

The first model we fit is to all of the data and output the median,
2.5th, and 97.5th quantiles (and their confidence intervals):

<img src="README_files/figure-markdown_strict/dic-plots-1.png" style="display: block; margin: auto;" />

<table>
<thead>
<tr class="header">
<th></th>
<th style="text-align: right;">est</th>
<th style="text-align: right;">CIlow</th>
<th style="text-align: right;">CIhigh</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>p2.5</td>
<td style="text-align: right;">2.542</td>
<td style="text-align: right;">1.829</td>
<td style="text-align: right;">3.564</td>
</tr>
<tr class="even">
<td>p5</td>
<td style="text-align: right;">2.850</td>
<td style="text-align: right;">2.153</td>
<td style="text-align: right;">3.849</td>
</tr>
<tr class="odd">
<td>p25</td>
<td style="text-align: right;">4.052</td>
<td style="text-align: right;">3.411</td>
<td style="text-align: right;">4.859</td>
</tr>
<tr class="even">
<td>p50</td>
<td style="text-align: right;">5.174</td>
<td style="text-align: right;">4.460</td>
<td style="text-align: right;">6.037</td>
</tr>
<tr class="odd">
<td>p75</td>
<td style="text-align: right;">6.608</td>
<td style="text-align: right;">5.474</td>
<td style="text-align: right;">8.062</td>
</tr>
<tr class="even">
<td>p95</td>
<td style="text-align: right;">9.394</td>
<td style="text-align: right;">6.887</td>
<td style="text-align: right;">12.844</td>
</tr>
<tr class="odd">
<td>p97.5</td>
<td style="text-align: right;">10.531</td>
<td style="text-align: right;">7.381</td>
<td style="text-align: right;">15.051</td>
</tr>
</tbody>
</table>

The median incubation period lasts 5.174 days (CI: 4.46-6.037). The
fastest incubation periods pass in 2.542 days (CI: 1.829-3.564), while
the longest ones take 10.531 days (CI: 7.381-15.051).

Alternate estimates and sensitivity analyses
--------------------------------------------

To make sure that our overall incubation estimates are sound, we ran a
few analyses on subsets to see if the results held up. Since the winter
often brings cold air and other pathogens that can cause sore throats
and coughs, we ran an analysis using only cases that reported a fever.
Since a plurality of our cases came from Mainland China, where
assumptions about local transmission may be less firm, we ran an
analysis without those cases. Finally, we challenge our assumption that
unknown ELs can be assumed to be 2019 December 1 ([Nextstrain estimates
that it could have happened as early as
September](https://nextstrain.org/ncov?dmax=2019-12-04&m=num_date)), by
setting unknown ELs to 2018 December 1.

<img src="README_files/figure-markdown_strict/all-est-plot-1.png" style="display: block; margin: auto;" />

Using only fevers, the estimates are 0.377 to 0.854 days longer than the
estimates on the full data. 8 of the cases with a fever reported having
other symptoms beforehand. While it may take a little longer for an
exposure to cause a fever, the estimates are similar to those of the
overall results. The confidence intervals are wider here at every
quantile due to having less data.

Using only cases from outside of Mainland China, the estimates are
-0.091 to 2.461 days longer than the estimates on the full data. There
is a bit of a gap on the long end of the tail, but the confidence
intervals overlap for the most part.

When we set the unknown ELs to 2018 December 1 instead of 2019 December
1, the estimates are -0.002 to 0.366 days longer than the estimates on
the full data. Somewhat surprisingly, this changes the estimates less
than either of the other alternate estimates.

Comparison to Backer
--------------------

[Backer, Klinkenberg, &
Wallinga](https://www.medrxiv.org/content/10.1101/2020.01.27.20018986v1.full.pdf+html)
estimated the incubation windows based on 34 early nCoV cases that
traveled from Wuhan to other regions in China. A comparison of our
incubation windows are shown below:

<img src="README_files/figure-markdown_strict/comparison-1.png" style="display: block; margin: auto;" />

The median estimates from all models lie between 5.1 and 5.765. The
reduction in confidence interval widths may be due to the difference in
the number of observations used to estimate each model.

*(Qulu Zheng, Hannah Meredith, Kyra Grantz, Qifang Bi, Forrest Jones,
and Stephen Lauer all contributed to this project)*
