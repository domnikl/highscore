module Highscore
  # keywords that were found in content
  #
  class Keywords < Hash

    # ranks the keywords and removes keywords that have a low ranking
    # or are blacklisted
    #
    # :call-seq:
    #   rank -> array
    #
    def rank
      filter
      sort_it
    end

    # get the top n keywords
    #
    def top n = 10
      filter
      rank[0..(n - 1)]
    end

    # sorts the keywords and returns a array of arrays
    #
    # :call-seq:
    #   sort_it -> array
    #
    def sort_it
      sort {|x,y| y[1] <=> x[1]}
    end

    private

    # filter out unwanted results
    #
    def filter
      run_blacklist
      filter_low
    end

    # filter low ranked keywords
    #
    def filter_low
      delete_if do |key, value|
        value <= 1
      end
    end

    # remove blacklisted keywords
    #
    def run_blacklist
      # FIXME: add more keywords!
      delete_if do |key, value|
        %w{the and that post add not see about using some something under our comments comment run you want for will file are with end new this use all but can your just get very data blog format out first posts second}.include? key
      end
    end
  end
end