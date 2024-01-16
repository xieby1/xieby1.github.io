#!/usr/bin/env python3
import pandas as pd
import plotly.graph_objects as go
import math

df = pd.read_excel("/home/xieby1/Documents/Tech/Essays.xlsx")
df.fillna(0, inplace=True)
fig = go.Figure()

count = 0
for index, row in df.iterrows():
    if (row.iloc[0] == "N"):
        continue

    count += 1

    filepath = row.iloc[1]
    year: int = int(row.iloc[2])
    abbr_title: str = row.iloc[3]
    abbr_author: str = row.iloc[4]
    abbr_publisher: str = row.iloc[5]
    citations: int = int(row.iloc[6] or 0)
    title: str = row.iloc[9]

    fig.add_scatter(
        x=[year],
        y=[filepath],
        marker_size = 5 + 2 * math.log2(citations + 1),
        hovertemplate =
        ("Title: %s<br>" % title) +
        ("Year: %d<br>" % year) +
        ("Category: %s<br>" % filepath) +
        ("Abbr Title: %s<br>" % abbr_title) +
        ("Abbr Author: %s<br>" % abbr_author) +
        ("Abbr Publisher: %s<br>" % abbr_publisher) +
        ("Citations: %d<br>" % citations),
    )

fig.update_yaxes(categoryorder="category descending", automargin=True)
fig.update_layout(
    height=count*6,
    showlegend=False,
    template="plotly_white",
)
fig.write_html(
    "./src/my_Essays_bubble.html",
    include_plotlyjs="https://cdn.bootcdn.net/ajax/libs/plotly.js/2.25.2/plotly.min.js",
)
