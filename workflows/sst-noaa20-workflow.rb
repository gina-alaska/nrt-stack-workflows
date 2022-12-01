steps = {}

#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "Noaa20ViirsSdrJob").first

#SST
steps[:sst] = Step.where(name: 'NOAA20SSTJob').first_or_create({
  enabled: false,
  queue: 'cspp_extras',
  command: 'acspo_level2.rb -m npp -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'acspo_level2').first_or_create,
  parent: steps[:viirs_sdr]
})

steps[:sst_awips] = Step.where(name: 'Noaa20SSTAwipsJob').first_or_create({
  enabled: false,
  queue: 'polar2grid',
  command: 'acspo_awips.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'sst_awips').first_or_create,
  parent: steps[:sst]
})

steps[:sst_geotiff] = Step.where(name: 'Noaa20SSTGeotifJob').first_or_create({
  enabled: false,
  queue: 'polar2grid',
  command: 'acspo_geotif.rb -m viirs -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'sst_geotif').first_or_create,
  parent: steps[:sst]
})

