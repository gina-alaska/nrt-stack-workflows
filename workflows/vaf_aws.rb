steps = {}
#******* NOAA20
#Noaa20ViirsFireJob
steps[:noaa20_fire] = Step.where(name: "Noaa20ViirsFireJob").first

steps[:noaa20_fire_aws] = Step.where(name: "Noaa20ViirsVAFAWSUpload").first_or_create({
  command: "vaf_insert.bash {{job.input_path}}",
  queue: 'geotiff',
  producer: false,
  parent: steps[:noaa20_fire]
})


# SNPP
#SNPPViirsFireJob
steps[:snpp_fire] = Step.where(name: "SNPPViirsFireJob").first

steps[:noaa20_fire_aws] = Step.where(name: "SNPPViirsVAFAWSUpload").first_or_create({
  command: "vaf_insert.bash {{job.input_path}}",
  queue: 'geotiff',
  producer: false,
  parent: steps[:snpp_fire]
})

# NOAA21
#Noaa21ViirsFireJob
steps[:noaa21_fire] = Step.where(name: "Noaa21ViirsFireJob").first

steps[:noaa21_fire_aws] = Step.where(name: "Noaa21ViirsVAFAWSUpload").first_or_create({
  command: "vaf_insert.bash {{job.input_path}}",
  queue: 'geotiff',
  producer: false,
  parent: steps[:snpp_fire]
})
