steps = {}
#*******                 NOAA20
#VIIRS SDR
steps[:noaa20_fire] = Step.where(name: "Noaa20ViirsFireJob").first

steps[:noaa20_fire_convert] = Step.where(name: "Noaa20ViirsFireConvertJob").first_or_create({
  command: "vaf_awips_reformat.rb t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'FireAwips').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:noaa20_fire]
})
steps[:noaa20_fire_ldm] = Step.where(name: 'Noaa20ViirsFireConvertLDMJob').first_or_create({
  command: 'pqinsert.rb -t . {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:noaa20_fire_convert],
  enabled: true
})

steps[:snpp_fire] = Step.where(name: "SNPPViirsFireJob").first

steps[:snpp_fire_convert] = Step.where(name: "SNPPViirsFireConvertJob").first_or_create({
  command: "vaf_awips_reformat.rb t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'FireAwips').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:snpp_fire]
})
steps[:snpp_fire_ldm] = Step.where(name: 'SNPPViirsFireConvertLDMJob').first_or_create({
  command: 'pqinsert.rb -t . {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:snpp_fire_convert],
  enabled: true
})


