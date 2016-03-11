class MagentoWorker < DefaultWorker

  sidekiq_options :queue => :magento

end