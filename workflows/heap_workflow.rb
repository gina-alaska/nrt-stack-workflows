steps = {}
#*******                 NOAA20
#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "Noaa20ViirsSdrJob").first

steps[:heap] = Step.where(name: "NOAA20Nucaps").first_or_create({
  command: "nucaps_l2.rb -m npp -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'nucaps_level2').first_or_create,
  sensor: Sensor.where(name: 'atms').first_or_create,
  parent: steps[:viirs_sdr]
})
steps[:heap_covert] = Step.where(name: "Noaa20NucapsConvert").first_or_create({
  command: "heap_awips_reformat.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'NucapsAwips').first_or_create,
  sensor: Sensor.where(name: 'atms').first_or_create,
  parent: steps[:heap]
})


steps = {}
#*******                 SNPP
#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "ViirsSdrJob").first
steps[:heap] = Step.where(name: "SNPPNucaps").first_or_create({
  command: "nucaps_l2.rb -m npp -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'nucaps_level2').first_or_create,
  sensor: Sensor.where(name: 'atms').first_or_create,
  parent: steps[:viirs_sdr]
})
steps[:heap_covert] = Step.where(name: "SnppNucapsConvert").first_or_create({
  command: "heap_awips_reformat.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'NucapsAwips').first_or_create,
  sensor: Sensor.where(name: 'atms').first_or_create,
  parent: steps[:heap]
})


#metop-c
steps = {} 
steps[:l1] = Step.where(name: "MetopC_L1").first

steps[:heap] = Step.where(name: "MetopCNucaps").first_or_create({
  command: "nucaps_l2.rb -m metop-c -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'nucaps_level2').first_or_create,
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  parent: steps[:l1]
})
steps[:heap_covert] = Step.where(name: "MetopCNucapsConvert").first_or_create({
  command: "heap_awips_reformat.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'NucapsAwips').first_or_create,
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  parent: steps[:heap]
})

#metop-b
steps = {}
steps[:l1] = Step.where(name: "MetopBL1").first

steps[:heap] = Step.where(name: "MetopBNucaps").first_or_create({
  command: "nucaps_l2.rb -m metop-c -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'nucaps_level2').first_or_create,
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  parent: steps[:l1]
})
steps[:heap_covert] = Step.where(name: "MetopBNucapsConvert").first_or_create({
  command: "heap_awips_reformat.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'NucapsAwips').first_or_create,
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  parent: steps[:heap]
})


