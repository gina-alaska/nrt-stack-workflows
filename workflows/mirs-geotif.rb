steps={}
command="p2g_geotif.rb -m mirs -t {{workspace}} {{job.input_path}} {{job.output_path}}"
queue="polar2grid"
processing_level = ProcessingLevel.where(name: 'mirs_geotif_l1').first_or_create

#metop-b,c
steps[:metopb_mirs] = Step.where(name: "MetopMirsL2").first
steps[:metopb_mirs_p2g_float] = Step.where(name: "MetopMirsL2Float").first_or_create({
  command: command,
  queue: queue,
  processing_level: processing_level,
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  parent: steps[:metopb_mirs]
})

steps[:metopc_mirs] = Step.where(name: "MetopCMirsL2").first
steps[:metopc_mirs_p2g_float] = Step.where(name: "MetopCMirsL2Float").first_or_create({
  command: command,
  queue: queue,
  processing_level: processing_level,
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  parent: steps[:metopc_mirs]
})
#noaa-poes
steps[:noaa19_mirs] = Step.where(name: "Noaa19MirsL2").first
steps[:noaa19_mirs_p2g_float] = Step.where(name: "Noaa19MirsL2Float").first_or_create({
  command: command,
  queue: queue,
  processing_level: processing_level,
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  parent: steps[:noaa19_mirs]
})
#snpp
steps[:snpp_mirs] = Step.where(name: "AtmsMirsJob").first
steps[:snpp_mirs_p2g_float] = Step.where(name: "SnppMirsL2Float").first_or_create({
  command: command,
  queue: queue,
  processing_level: processing_level,
  sensor: Sensor.where(name: 'atms').first_or_create,
  parent: steps[:snpp_mirs]
})
#noaa20
steps[:noaa20_mirs] = Step.where(name: "Noaa20AtmsMirsJob").first
steps[:noaa20_mirs_p2g_float] = Step.where(name: "Noaa20MirsL2Float").first_or_create({
  command: command,
  queue: queue,
  processing_level: processing_level,
  sensor: Sensor.where(name: 'atms').first_or_create,
  parent: steps[:noaa20_mirs]
})
