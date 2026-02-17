steps = {}
#*******                 SNPP
steps[:scmi] = Step.where(name: "SnppViirsSCMI").first
#---------------- NUCAPS
# SDR
steps[:scmi_upload] = Step.where(name: 'SnppViirsSCMICloudUpload').first_or_create({
  enabled: true,
  queue: 'geotiff',
  command: 'awips_s3_push.rb -t {{workspace}} {{job.input_path}}',
  producer: false,
  parent: steps[:scmi],
  enabled: true  
})

steps = {}
#*******                 NOAA20
steps[:scmi] = Step.where(name: "NOAA20SnppViirsSCMI").first
#---------------- NUCAPS
# SDR
steps[:scmi_upload] = Step.where(name: 'Noaa20ViirsSCMICloudUpload').first_or_create({
  enabled: true,
  queue: 'geotiff',
  command: 'awips_s3_push.rb -t {{workspace}} {{job.input_path}}',
  producer: false,
  parent: steps[:scmi],
  enabled: true  
})

steps = {}
#*******                 NOAA21
steps[:scmi] = Step.where(name: "Noaa21SnppViirsSCMI").first
#---------------- NUCAPS
# SDR
steps[:scmi_upload] = Step.where(name: 'Noaa21ViirsSCMICloudUpload').first_or_create({
  enabled: true,
  queue: 'geotiff',
  command: 'awips_s3_push.rb -t {{workspace}} {{job.input_path}}',
  producer: false,
  parent: steps[:scmi],
  enabled: true  
})
