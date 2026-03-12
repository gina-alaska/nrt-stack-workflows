require 'pp'
steps = {}
sources = []


sources += %w[Noaa21ViirsSdrJob ViirsSdrJob Noaa20ViirsSdrJob]

pp sources

sources.each do |task|
  parent = task.to_sym
  task_stub = task.gsub("SdrJob", "")
  task_sym = (task_stub + 'Job').to_sym
  steps[parent] = Step.where(name: task).first
  if !steps[parent] 
	put("didn't find #{task}!")
	exit
  end
  steps[task_sym] = Step.where(name: task_stub + 'AggJob').first_or_create({
                                                                         command: 'nagger.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
                                                                         queue: 'cspp_sdr',
                                                                         producer: true,
                                                                         processing_level: ProcessingLevel.where(name: 'level1_agg').first_or_create,
                                                                         sensor: Sensor.where(name: 'viirs').first_or_create,
                                                                         enabled: true,
                                                                         parent: steps[parent]
                                                                       })
end
