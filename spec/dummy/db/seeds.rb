APPLICATION_ENGINES.each { |engine| engine[:railtie].load_seed } if defined? APPLICATION_ENGINES
