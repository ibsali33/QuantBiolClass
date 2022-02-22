# Data upload and import #######################################################################

# Create a "data" directory
dir.create("Data/RNAData")

# Download the data 
# Use a loop to automate this step
for(i in c("counts_raw.csv", "counts_transformed.csv", "sample_info.csv", "test_result.csv")){
  download.file(
    url = paste0("https://github.com/tavareshugo/data-carpentry-rnaseq/blob/master/data/", i, "?raw=true"),
    destfile = paste0("Data/RNAData/", i)
  )
}

# Import the data in the environment
# raw_cts = read.csv("Data/RNAData/counts_raw.csv")
trans_cts = read.csv("Data/RNAData/counts_transformed.csv")
sample_info = read.csv("Data/RNAData/sample_info.csv")
test_result = read.csv("Data/RNAData/test_result.csv")

# Data subsetting #######################################################################

# To subset the data, we will run a principal component analysis
# to identify the genes explaining most of the variance
# This part is redundant with module 3.1, but considers a bigger data set

# Create a matrix from our table of counts
pca_matrix <- trans_cts %>% 
  # make the "gene" column become the rownames of the table
  column_to_rownames("gene") %>% 
  # coerce to a matrix
  as.matrix() %>% 
  # transpose the matrix so that rows = samples and columns = variables
  t()

# Run the PCA
pca_scale <- prcomp(pca_matrix, scale = TRUE)

# Extract the PC loadings
pc_loadings <- as.data.frame(pca_scale$rotation)
pc_loadings$gene = rownames(pc_loadings)
pc_loadings = pc_loadings %>% relocate(gene)

# Identify the 'top genes', explaining to most of the variance
top_genes <- pc_loadings %>% 
  # select only the PCs we are interested in
  select(gene, PC1, PC2) %>%
  # convert to a "long" format
  pivot_longer(matches("PC"), names_to = "PC", values_to = "loading") %>% 
  # for each PC
  group_by(PC) %>% 
  # arrange by descending order of loading
  arrange(desc(abs(loading))) %>% 
  # take the 10 top rows
  slice(1:10) %>% 
  # pull the gene column as a vector
  pull(gene) %>% 
  # ensure only unique genes are retained
  unique()

# Create a filtered data set, with only the top genes
trans_cts_sub = trans_cts[is.element(trans_cts$gene, top_genes), ]

# Save this data set
write.csv(trans_cts_sub, "Data/RNAData/counts_transformed_subset.csv", row.names = F)
