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

# EDR:
list=["Noaa21ViirsEdrScmi", "Noaa20ViirsEdrScmi", "ViirsEdrJobSCMI", "MetopCMirsSCMI", "MetopC_SCMIAwips", "MetopBMirsSCMI", "MetopSCMIAwips", "Noaa21AtmsMirsSCMIJob", "Noaa20AtmsMirsSCMIJob"]
clarvx_list = ["NOAA20_CLAVRX_AWIPS_Job", "SNPP_CLAVRX_AWIPS_Job", "MetopB_CLAVRX_AWIPS_Job", "MetopC_CLAVRX_AWIPS_Job"]
list += clarvx_list
list.each do |item|
    steps = {}
    steps[:scmi] = Step.where(name: item).first
    steps[:scmi_upload] = Step.where(name: item + 'CloudUpload').first_or_create({
      enabled: true,
      queue: 'geotiff',
      command: 'awips_s3_push.rb -t {{workspace}} {{job.input_path}}',
      producer: false,
      parent: steps[:scmi],
      enabled: true  
  })
end



