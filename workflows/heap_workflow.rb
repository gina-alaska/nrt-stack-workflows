steps = {}
#*******                 NOAA20
#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "NOAA20NucapsSdrJob").first

steps[:heap] = Step.where(name: "NOAA20Nucaps").first_or_create({
  command: "nucaps_l2.rb -m noaa20 -t {{workspace}} {{job.input_path}} {{job.output_path}}",
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

steps[:heap_ldm] = Step.where(name: 'Noaa20NucapsLdmInject').first_or_create({
  command: 'pqinsert.rb -t . {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:heap_covert],
  enabled: true
})


steps = {}
#*******                 SNPP
#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "NucapsSdrJob").first
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

steps[:heap_ldm] = Step.where(name: 'SnppNucapsLdmInject').first_or_create({
  command: 'pqinsert.rb -t . {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:heap_covert],
  enabled: true
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

steps[:heap_ldm] = Step.where(name: 'MetopCNucapsLdmInject').first_or_create({
  command: 'pqinsert.rb -t . {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:heap_covert],
  enabled: true
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

steps[:heap_ldm] = Step.where(name: 'MetopBNucapsLdmInject').first_or_create({
  command: 'pqinsert.rb -t . {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:heap_covert],
  enabled: true
})
