Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::WillPaginate
Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL']
