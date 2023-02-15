# THỰC HÀNH LẬP BẢN ĐỒ SỬ DỤNG PHẦN MỀM R #

# 1. TẢI VÀ CÀI ĐẶT GÓI ỨNG DỤNG CẦN THIẾT
# 2. TẢI TỆP DỮ LIỆU BẢN ĐỒ 
# 3. NHẬP DỮ LIỆU BẢN ĐỒ VÀ CHUYỂN ĐỔI HỆ QUY CHIẾU 
# 4. BIÊN TẬP DỮ LIỆU BẢN ĐỒ
# 5. LẬP BẢN ĐỒ VÀ TRÌNH DIỄN DỮ LIỆU
# 6. XUẤT BẢN ĐỒ THÀNH FILE ẢNH
# 7. NGUỒN THAM KHẢO THÔNG TIN

# 1. TẢI VÀ CÀI ĐẶT GÓI ỨNG DỤNG CẦN THIẾT

setwd("C:/Users/admin/Documents/R/Geo Map")
# getwd()
# browseURL(getwd())
# install.packages(c("sf", "mapsf", "xlsx")) # Nếu  bạn chưa cài đặt
lapply(c("sf", "mapsf", "xlsx"), library, character.only = TRUE)

# 2. TẢI TỆP DỮ LIỆU BẢN ĐỒ 
browseURL("https://data.humdata.org/dataset/cod-ab-vnm")
# Tải về máy tính
# Giải nén vào thư mục làm việc
# The files PRJ, SHP, DBF, SHX, CPG are needed to work together
browseURL(getwd())
# 3. NHẬP DỮ LIỆU BẢN ĐỒ VÀ CHUYỂN ĐỔI HỆ QUY CHIẾU 
# provincess_sf <- st_read("vnm_admbnda_adm1_gov_20201027.shp")
# provincess_sf <- st_transform(provincess_sf, 32648)
# View(provincess_sf)

districtss_sf <- st_read("vnm_admbnda_adm2_gov_20201027.shp")
# class(districtss_sf)
# str(districtss_sf)
# dim(districtss_sf)
# View(districtss_sf)

districtss <- st_transform(districtss_sf, 32648) # 32648 is targeted reference system code for UTM Zone 48
# https://mangomap.com/robertyoung/maps/69585/what-utm-zone-am-i-in-#
# browseURL("https://spatialreference.org/ref/") to know the code of the respective region

# Thử lập một bản đồ mẫu
mf_map(districtss, col = "#F0FFFF", border = "red")
mf_map(districtss, col = "#F0FFFF", border = "black")

# Thầm các thành phần khác của bản đồ
# Tiêu đề
mf_title("Base Maps of Viet Nam, 2023", pos = "center", bg = "#9ebcda", fg = "red")
# Chỉ hướng
mf_arrow()
# Thước đo tỷ lệ xích
mf_scale(100)

# 4. BIÊN TẬP DỮ LIỆU BẢN ĐỒ
########################################
# Generate data sample for mapping #####
############## Begin ###################
########################################
View(districtss_sf)
# Generate Unique code
DCODE <- seq("0001", "0708", by = 1) # length(DCODE)
# Make a data frame with case and unique Code
pop_DCODE <- read.xlsx("pop_DCODE.xlsx", sheetIndex = 1, header = TRUE)
# Check the data frame
head(pop_DCODE)
tail(pop_DCODE)
# Add DCODE to spatial data frame
district_sf_DCODE <- cbind(districtss_sf, DCODE)

district_sf_DCODE <- st_transform(district_sf_DCODE, 32648)

# Check the spatial data with DCODE
head(district_sf_DCODE)  
View(district_sf_DCODE)  
dim(district_sf_DCODE)
# Now we merge two dataset, a spatial data frame and a data frame
district_sf_DCODE_pop <- merge(district_sf_DCODE, pop_DCODE, by = "DCODE")
dim(district_sf_DCODE_pop)
View(district_sf_DCODE_pop)
# head(district_sf_DCODE_pop)
# convert to numeric
# is.numeric(district_sf_DCODE_pop$pop)
# district_sf_DCODE_pop$pop <- as.numeric(district_sf_DCODE_pop$pop)
########################################
# Generate data sample for mapping #####
############## End #####################
########################################
# 5. LẬP BẢN ĐỒ VÀ TRÌNH DIỄN DỮ LIỆU
########################################
########### BEGIN MAPPING ##############
########################################

mf_map(district_sf_DCODE_pop,
       var = "case",
       # inches = .2,
       # type = "prop",
       type = "choro",
       breaks = "quantile",
       nbreaks = 5,
       pal = "BuGn",
       col = "#000066",
       leg_val_rnd = 0,
       leg_title = "Number of cases/100k",
       leg_pos = "interactive"
       # leg_pos = c(230133.440283276, 1773555.0531706) 
       #add = TRUE
       # c(97.7718329513662, 17.3989831602692)
       
)
mf_title("Maps of COVID-19 in Viet Nam, 2021", pos = "center", bg = "ivory4")
mf_arrow() #mf_arrow(pos = "topright"), mũi tên chỉ hướng Bắc
mf_credits("EPI-TEAM 2022")
mf_scale(100) # thước đo tỷ lệ xích

########################################
#####Chọn 28 tỉnh khu vực miền Bắc######
########################################

sort(unique(district_sf_DCODE_pop$ADM1_EN))
# View(district_sf_DCODE_pop)

# Chọn 28 tỉnh miền Bắc
provs <- c("Bac Giang", "Ha Nam", "Ha Tinh", "Hai Phong city",
           "Hung Yen", "Lang Son", "Quang Ninh", "Thai Nguyen", 
           "Yen Bai", "Vinh Phuc", "Tuyen Quang", "Thanh Hoa", 
           "Thai Binh", "Son La", "Ninh Binh", "Nam Dinh", 
           "Lao Cai", "Hoa Binh", "Hai Duong", "Bac Ninh", 
           "Bac Kan", "Cao Bang", "Dien Bien", "Ha Noi", "Ha Giang", 
           "Phu Tho", "Nghe An", "Lai Chau")


# district_sf_DCODE_pop$NAME_1[!district_sf_DCODE_pop$NAME_1 %in% provs]
# unique(provs)
dfnorth <- district_sf_DCODE_pop[district_sf_DCODE_pop$ADM1_EN %in% provs,]
# pfnorth <- provincess_sf[provincess_sf$ADM1_EN %in% provs,]
# pfnorth$ADM1_EN
# dfnorth$ADM2_EN
# Subsetting
# View(dfnorth)
# dim(dfnorth)

mf_map(dfnorth,
       var = "case",
       # inches = .2,
       # type = "prop",
       type = "choro",
       breaks = "quantile",
       nbreaks = 5,
       pal = "BuGn",
       col = "#000066",
       leg_val_rnd = 0,
       leg_title = "Number of cases/100k",
       leg_pos = "interactive"
       # leg_pos = c(266508.112828816, 2246992.11620684)
       # c(97.7718329513662, 17.3989831602692)
     
)

mf_title("Maps of COVID-19 in Northern Viet Nam, 2023", pos = "center", bg = "ivory4")
mf_arrow() #mf_arrow(pos = "topright")
mf_credits("EPI-TEAM 2022")
mf_scale(100)

########################################
########################################
########################################

# Combine all three maps
# dev.new()
mf_export(dfnorth, filename="mymap2.svg", 11.7, 8.27, res = 300) # Mở thư mục hiện tại

par(mfrow = c(1,3))
# Map 1
mf_map(districtss, col = "#F0FFFF", border = "red")
mf_title("Base Maps of Viet Nam, 2023", pos = "center", bg = "#9ebcda", fg = "red")
mf_arrow()
mf_credits("EPI-TEAM 2023")
mf_scale(100)

# Map 2
mf_map(district_sf_DCODE_pop,
       var = "case",
       # inches = .2,
       # type = "prop",
       type = "choro",
       breaks = "quantile",
       nbreaks = 5,
       pal = "BuGn",
       col = "#000066",
       leg_val_rnd = 0,
       leg_title = "Number of cases/100k",
       # leg_pos = "interactive"
       leg_pos = c(224663.676108011, 1738554.28152924) 
       # add = TRUE
       # c(97.7718329513662, 17.3989831602692)
       
)

mf_title("Maps of COVID-19 in Viet Nam, 2023", pos = "center", bg = "ivory4", fg = "#000000", font = 1)
mf_arrow() #mf_arrow(pos = "topright")
mf_credits("EPI-TEAM 2023")
mf_scale(100)

# Map 3
mf_map(dfnorth,
       var = "case",
       # inches = .2,
       # type = "prop",
       type = "choro",
       breaks = "quantile",
       nbreaks = 5,
       pal = "BuGn",
       col =  "#000066",
       border = "#756bb1", # "#29a3a3"
       leg_val_rnd = 0,
       leg_title = "Number of cases/100k",
       # leg_pos = "interactive"
       leg_pos = c(265506.47544619, 2242161.60133078)
       # c(97.7718329513662, 17.3989831602692)
       
)
# Thêm các thành phần khác của bản đồ
mf_title("Maps of COVID-19 in Northern Viet Nam, 2023", pos = "center", bg = "ivory4")
mf_arrow() #mf_arrow(pos = "topright")
mf_credits("EPI-TEAM 2023")
mf_scale(100)

dev.off()

browseURL(getwd())
# 6. XUẤT BẢN ĐỒ THÀNH FILE ẢNH
# pdf, JPEG, SVG, PNG, TIFF ...
mf_export(dfnorth, filename="mymap2023.svg", 11.7, 8.27, res = 300) # Thư mục hiện tại

mf_map(dfnorth,
       var = "case",
       # inches = .2,
       # type = "prop",
       type = "choro",
       breaks = "quantile",
       nbreaks = 5,
       pal = "BuGn",
       col =  "#000066",
       border = "#756bb1", # "#29a3a3"
       leg_val_rnd = 0,
       leg_title = "Number of cases/100k",
       #leg_pos = "interactive"
       leg_pos = c(265506.47544619, 2242161.60133078)
       # c(97.7718329513662, 17.3989831602692)
       
)

# View(dfnorth)

mf_label(
  x = dfnorth,
  # x = pfnorth,
  # var = "ADM1_EN",
  var = "ADM2_EN",
  col= "darkgreen",
  halo = TRUE,
  overlap = FALSE, 
  # cex = 0.1,
  cex = 0.8,
  # lines = FALSE
  lines = TRUE
)

mf_title("Maps of COVID-19 in Northern Viet Nam, 2023", pos = "center", bg = "ivory4")
mf_arrow() # mf_arrow(pos = "topright")
mf_credits("EPI-TEAM 2023")
mf_scale(100)

dev.off() # use the code block sf_export(...) ... dev.off() to save the map

browseURL(getwd())

# 7. NGUỒN THAM KHẢO THÔNG TIN
# References
# A map data source Vietnam with Paracel and Spratly islands:
browseURL("https://data.humdata.org/dataset/cod-ab-vnm")
# sử dụng biểu tượng
browseURL("https://riatelab.github.io/mapsf/articles/mapsf.html#symbology")
# Training content
browseURL("http://rspatial4onehealth.geohealthresearch.org/")
browseURL("https://colorbrewer2.org/")
# Spatial geomapping data sources
browseURL("https://www.netvibes.com/geohealth?page=geohealth#Online_databases")
