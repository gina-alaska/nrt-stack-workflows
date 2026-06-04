steps = Hash.new
# Set up steps
steps[:arrival] = Step.where(name: "MetopSga1_Arrival").first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
  })
steps[:l0] = Step.where(name: "MetopSga1_L0").first_or_create({
  processing_level: ProcessingLevel.where(name: 'level0').first_or_create,
  command: "rtstps.rb -p metop-sga1 -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  queue: 'rtstps',
  parent: steps[:arrival]
})
steps[:l1] = Step.where(name: "MetopSga1_L1").first_or_create({
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create,
  queue: 'aapp',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "metop_sga_l1.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:l0]
})

#----------------------------------                   AVHRR
# AWIPS
steps[:awips] = Step.where(name: "MetopSga1_Awips").first_or_create({
  processing_level: ProcessingLevel.where(name: 'awips').first_or_create,
  queue: 'polar2grid',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "metop_awips.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  enabled: false,
  parent: steps[:l1]
})

#AWIPS LDM
steps[:ldm] = Step.where(name: "MetopSga1_LDMInject").first_or_create({
  command: "pqinsert.rb {{job.input_path}}",
  queue: 'ldm',
  producer: false,
  parent: steps[:awips],
  enabled: false
})

#SCMI
steps[:scmi_awips] = Step.where(name: "MetopSga1_SCMIAwips").first_or_create({
  processing_level: ProcessingLevel.where(name: 'awips').first_or_create,
  queue: 'polar2grid',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "awips_scmi.rb -m avhrr -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  enabled: false,
  parent: steps[:l1]
})

#SCMI LDM
steps[:scmi_ldm] = Step.where(name: "MetopSga1_SCMILDMInject").first_or_create({
  command: "pqinsert.rb {{job.input_path}}",
  queue: 'ldm',
  producer: false,
  parent: steps[:scmi_awips],
  enabled: false
})

#---------------------------------                    GEOTIFF
steps[:geotiff_l1] = Step.where(name: "MetopSga1_GeoTiff_l1").first_or_create(
  processing_level: ProcessingLevel.where(name: 'geotiff_l1').first_or_create,
  queue: 'polar2grid',
  sensor: Sensor.where(name: 'metimage').first_or_create,
  command: "p2g_geotif.rb -p 2 -m metimage -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:l1])
steps[:geotiff_l2] = Step.where(name: "MetopSga1_GeoTiff_l2").first_or_create(
  processing_level: ProcessingLevel.where(name: 'geotiff_l2').first_or_create,
  queue: 'geotiff',
  sensor: Sensor.where(name: 'metimage').first_or_create,
  command: "feeder_geotif.rb -m metop-sga1 -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:geotiff_l1])

# Bind workflows to satellite
sat = Satellite.friendly.find('metop-sga1')
sat.workflows << steps[:arrival] unless sat.workflows.include?(steps[:arrival])
