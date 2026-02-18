steps = {}
#*******                 SNPP
steps[:scmi] = Step.where(name: "SNPPViirsFireConvertJob").first
#---------------- NUCAPS
# SDR
steps[:scmi_upload] = Step.where(name: 'SNPPViirsFireConvertUpload').first_or_create({
  enabled: true,
  queue: 'geotiff',
  command: 'awips_s3_push.rb -t {{workspace}} {{job.input_path}}',
  producer: false,
  parent: steps[:scmi],
  enabled: true  
})

steps = {}
#*******                 NOAA20
steps[:scmi] = Step.where(name: "Noaa20ViirsFireConvertJob").first
#---------------- NUCAPS
# SDR
steps[:scmi_upload] = Step.where(name: 'Noaa20ViirsFireConvertUpload').first_or_create({
  enabled: true,
  queue: 'geotiff',
  command: 'awips_s3_push.rb -t {{workspace}} {{job.input_path}}',
  producer: false,
  parent: steps[:scmi],
  enabled: true  
})

steps = {}
#*******                 NOAA21
steps[:scmi] = Step.where(name: "N21NoaaFireConvert").first
#---------------- NUCAPS
# SDR
steps[:scmi_upload] = Step.where(name: 'N21NoaaFireConvertCloudUpload').first_or_create({
  enabled: true,
  queue: 'geotiff',
  command: 'awips_s3_push.rb -t {{workspace}} {{job.input_path}}',
  producer: false,
  parent: steps[:scmi],
  enabled: true  
})
