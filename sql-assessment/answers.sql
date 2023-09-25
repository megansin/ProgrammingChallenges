-- 1. Write a query to get the sum of impressions by day.

SELECT SUM(impressions)
FROM marketing_performance
GROUP BY date;

-- 2. Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?
-- The third best state (TX) generated ($34080) in revenue.

SELECT state, SUM(revenue) 
from website_revenue
GROUP BY state
ORDER BY revenue DESC
LIMIT 3;

-- 3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.

SELECT name, total_cost, total_impressions, total_clicks, SUM(w.revenue) as total_revenue
FROM
(SELECT c.name, c.id, SUM(m.cost) as total_cost, SUM(m.impressions) AS total_impressions, SUM(m.clicks) AS total_clicks
FROM campaign_info AS c
INNER JOIN marketing_performance AS m
ON c.id = m.campaign_id
GROUP BY c.id) AS inner_query
INNER JOIN website_revenue as w
ON inner_query.id = w.campaign_id
GROUP BY id;

-- 4. Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?
-- Georgia (GA) generated the most conversions for this campaign (Campaign5)

SELECT geo, COUNT(conversions)
FROM marketing_performance AS m
INNER JOIN campaign_info AS c
ON m.campaign_id = c.id
WHERE c.name = 'Campaign5'
GROUP BY geo;

-- 5. In your opinion, which campaign was the most efficient, and why?
-- In my opinion, using the query below, I think Campaign4 was the most efficient.
-- Campaign4 had the second largest return on investment (ROI) and the lowest cost per conversion. 
-- The campaign that had the largest ROI (Campaign5) also had the largest cost per conversion making it not the most efficient campaign.

SELECT name, total_cost/total_impressions AS cost_per_impression, 
total_cost/total_clicks AS cost_per_click, 
total_cost/total_conversions AS cost_per_conversion,
(SUM(revenue)-total_cost) / total_cost AS roi,
(SUM(revenue)/total_clicks) AS revenue_per_click
FROM
(SELECT c.name, c.id, SUM(m.conversions) AS total_conversions, SUM(m.cost) as total_cost, SUM(m.impressions) AS total_impressions, SUM(m.clicks) AS total_clicks
FROM campaign_info AS c
INNER JOIN marketing_performance AS m
ON c.id = m.campaign_id
GROUP BY c.id) AS inner_query
INNER JOIN website_revenue as w
ON inner_query.id = w.campaign_id
GROUP BY id
ORDER BY roi DESC, cost_per_conversion ASC;

-- **Bonus Question**
-- 6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.
-- The best day to run ads is Friday then followed by Saturday.

SELECT strftime('%w', substr(date,0,11)) AS DayOfWeek, SUM(impressions) AS total_impressions, SUM(clicks) AS total_clicks, SUM(conversions) AS total_conversions
FROM marketing_performance
GROUP BY DayOfWeek
ORDER BY total_impressions DESC, total_clicks DESC, total_conversions DESC;

