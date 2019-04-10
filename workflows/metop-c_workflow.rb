steps = Hash.new
# Set up steps
steps[:arrival] = Step.where(name: "MetopC_Arrival").first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
  })
steps[:l0] = Step.where(name: "MetopC_L0").first_or_create({
  processing_level: ProcessingLevel.where(name: 'level0').first_or_create,
  queue: 'aapp',
  command: "metop_l0.rb -s M03 -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  parent: steps[:arrival]
})
steps[:l1] = Step.where(name: "MetopC_L1").first_or_create({
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create,
  queue: 'aapp',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "metop_l1.rb -s M03 -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:l0]
})
steps[:awips] = Step.where(name: "MetopC_Awips").first_or_create({
  processing_level: ProcessingLevel.where(name: 'awips').first_or_create,
  queue: 'polar2grid',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "metop_awips.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:l1]
})
steps[:ldm] = Step.where(name: "MetopC_LDMInject").first_or_create({
  command: "pqinsert.rb {{job.input_path}}",
  queue: 'ldm',
  producer: false,
  parent: steps[:awips],
  enabled: false
})

#SCMI
steps[:scmi_awips] = Step.where(name: "MetopC_SCMIAwips").first_or_create({
  processing_level: ProcessingLevel.where(name: 'awips').first_or_create,
  queue: 'polar2grid',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "awips_scmi.rb -m avhrr -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:l1]
})
steps[:scmi_ldm] = Step.where(name: "MetopC_SCMILDMInject").first_or_create({
  command: "pqinsert.rb {{job.input_path}}",
  queue: 'ldm',
  producer: false,
  parent: steps[:scmi_awips],
  enabled: false
})


steps[:mirs_level2] = Step.where(name: "MetopC_MirsL2").first_or_create({
  processing_level: ProcessingLevel.where(name: 'l1').first_or_create,
  queue: 'cspp_extras',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "mirs_l0.rb -s metop-c -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:l1]
})

steps[:mirs_awips] = Step.where(name: "MetopC_MirsAwips").first_or_create({
  processing_level: ProcessingLevel.where(name: 'l1').first_or_create,
  queue: 'polar2grid',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "mirs_awips.rb -s amsu -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:mirs_level2]
})


steps[:geotiff_l1] = Step.where(name: "MetopC_GeoTiff_l1").first_or_create(
  processing_level: ProcessingLevel.where(name: 'geotiff_l1').first_or_create,
  queue: 'polar2grid',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "p2g_geotif.rb -p 2 -m avhrr -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:l1])
steps[:geotiff_l2] = Step.where(name: "MetopC_GeoTiff_l2").first_or_create(
  processing_level: ProcessingLevel.where(name: 'geotiff_l2').first_or_create,
  queue: 'geotiff',
  sensor: Sensor.where(name: 'avhrr').first_or_create,
  command: "feeder_geotif.rb -m metop-c -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  parent: steps[:geotiff_l1])

steps[:geotiff_l1].requirements = %w[polar2grid].map do |requirement|
  Requirement.where(name: requirement).first_or_create
end

steps[:geotiff_l2].requirements = %w[geotiff].map do |requirement|
  Requirement.where(name: requirement).first_or_create
end






# Set up requirements
steps[:l0].requirements = %w{aapp}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end
steps[:l1].requirements = %w{aapp}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end
steps[:awips].requirements = %w{polar2grid-2}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end
steps[:ldm].requirements = %w{ldm}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end

#MIRS

steps[:mirs_level2].requirements = %w{cspp_extras}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end

steps[:mirs_awips].requirements = %w{polar2grid-2}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end

#SCMI
steps[:scmi_awips].requirements = %w{polar2grid-2}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end

steps[:scmi_ldm].requirements = %w{ldm}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end

# Bind workflows to satellite
sat = Satellite.friendly.find('metop-c')
sat.workflows << steps[:arrival] unless sat.workflows.include?(steps[:arrival])
