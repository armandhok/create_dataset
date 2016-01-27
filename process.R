library(stringr)
library(plyr)
library(dplyr)
library(data.table)

######
## Read data
######
mat    <- read.csv("MAT.csv",
                  stringsAsFactors = FALSE)
invent <- read.csv("inventories_clean.csv",
                  stringsAsFactors = FALSE)
plans  <- read.csv("plans_clean.csv",
                  stringsAsFactors = FALSE)
dat.pres <- read.csv("dataset_presidencia.csv",
                    stringsAsFactors = FALSE)


######
## Filter data
######
mat  <-  dplyr::filter(mat, !is.na(slug))
mat.dc <-  data.table(mat)

######
## N rec, conj
######
rec   <-  mat.dc[, .N, by = "slug"]
conj  <-  mat.dc[, plyr::count(conj), by = "slug"]
conj.f  <-  conj[, .N, by = "slug"]

######
## fecha
######
dates <- mat.dc[, max(rec_fecha), by = "slug"]

######
## Put it all together
######
entities            <- data.frame(apply(mat[,c(1,2)], 2, unique))
entities$tiene_inv  <- entities$slug %in% invent$inst_slut
entities$tiene_plan <- entities$slug %in% plans$inst_slut
ent_rec             <- merge(entities, rec, by = "slug")
ent_rec_conj        <- merge(ent_rec, conj.f, by = "slug")
names(ent_rec_conj) <- c("slug",
                        "dep",
                        "tiene_inventario",
                        "tiene_plan",
                        "recursos",
                        "conjuntos")
ent_rec_conj <- merge(ent_rec_conj, dates, by = "slug")
names(ent_rec_conj) <- c("slug",
                        "dep",
                        "tiene_inventario",
                        "tiene_plan",
                        "recursos",
                        "conjuntos",
                        "fecha")
ent_rec_conj$fecha <- as.Date(ent_rec_conj$fecha)

### Refinemnts
ent_rec_conj$tiene_inventario[ent_rec_conj$tiene_inventario == TRUE] <- "Si"
ent_rec_conj$tiene_inventario[ent_rec_conj$tiene_inventario == FALSE] <- "No"
ent_rec_conj$tiene_plan [ent_rec_conj$tiene_plan == TRUE] <- "Si"
ent_rec_conj$tiene_plan [ent_rec_conj$tiene_plan == FALSE] <- "No"


final_data <- ent_rec_conj
final_data <- final_data[,-1]
final_data[,c(4,5)] <- final_data[,c(5,4)]
names(final_data) <- c("Nombre de la dependencia",
                      "¿Cuenta con Inventario de Datos?",
                      "¿Cuenta con Plan de Apertura?",
                      "Número de conjuntos de datos publicados",
                      "Número de recursos de datos publicados",
                      "Última fecha de actualización")

##############################
### Agregar datos sin recursos
##############################
new_data  <- data.frame("dep" = c("AGN","CENSIDA","PF"),
                       "inv" = rep("Si", 3),
                       "plan" = rep("Si", 3),
                       "conj" = rep(0,3),
                       "rec" = rep(0,3),
                       "fecha" = rep(NA, 3))

names(new_data) <- names(final_data)
final_data <- rbind(final_data, new_data)

write.csv(final_data,
          "dataset_presidencia.csv",
          row.names = FALSE)
