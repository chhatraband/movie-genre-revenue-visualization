library(ggplot2)
library(reshape2)


data <- data.frame(
  Genre = c("Action", "Adventure", "Animation", "Biography", "Comedy",
            "Crime", "Drama"),
  Revenue_2006_2010 = c(11219, 2380, 3024, 1037, 2793, 889, 2127),
  Revenue_2011_2015 = c(17671, 4572, 3546, 1703, 4292, 1085, 2896),
  Avg_Rating_2006_2010 = c(7, 7, 8, 8, 7, 7, 7),
  Avg_Rating_2011_2015 = c(7, 7, 7, 8, 7, 7, 7)
)

data_melt <- melt(data, id.vars = "Genre",
                  measure.vars = c("Revenue_2006_2010", "Revenue_2011_2015",
                                   "Avg_Rating_2006_2010", "Avg_Rating_2011_2015"),
                  variable.name = "Metric", value.name = "Value")


data_melt$Year_Group <- ifelse(grepl("2006_2010", data_melt$Metric),
                               "2006-2010", "2011-2015")
data_melt$Metric <- gsub("_2006_2010|_2011_2015", "", data_melt$Metric)


data_melt$Position <- as.numeric(factor(data_melt$Genre)) +
  ifelse(data_melt$Year_Group == "2011-2015", 7, 0)


ggplot() +
  
  geom_bar(data = subset(data_melt, Metric == "Revenue"),
           aes(x = Position, y = Value, fill = Genre),
           stat = "identity", width = 0.8) +
  
  geom_line(data = subset(data_melt, Metric == "Avg_Rating"),
            aes(x = Position, y = Value * 5000, group = Year_Group),
            color = "gray", size = 0.8) +
  geom_point(data = subset(data_melt, Metric == "Avg_Rating"),
             aes(x = Position, y = Value * 5000),
             color = "gray", size = 2) +
 
  
  geom_text(data = subset(data_melt, Metric == "Avg_Rating"),
            aes(x = Position, y = Value * 5000, label = round(Value, 1)),
            color = "black", vjust = -1, size = 3) +

  geom_text(data = subset(data_melt, Metric == "Revenue"),
            aes(x = Position, y = Value + 1000, label = Value),
            position = position_dodge(width = 0.8), angle = 0, hjust = 0.5, size = 3) +

  geom_vline(xintercept = 7.5, linetype = "dashed", color = "gray", size = 0.1) +
 
  scale_x_continuous(
    breaks = c(4, 11), 
    labels = c("2006-2010", "2011-2015"),  
    name = NULL,
    expand = c(0, 0)
  ) +

  scale_y_continuous(
    name = "Revenue (Millions)",
    sec.axis = sec_axis(~./5000, name = "Average Rating")
  ) +
  scale_fill_brewer(palette = "Set2", name = "Genre") + 
  labs(
    title = "Revenue and Average Ratings by Genre (2006-2015)",
    fill = "Genre"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 11, face = "bold"),  
    axis.ticks.x = element_blank(), 
    legend.position = "top",
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5)  
  )
