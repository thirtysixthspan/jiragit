module Jiragit

  class Vault

    def initialize(location)
      self.location = location
      load_or_create
    end

    def load_or_create
      self.vault = load || create
    end

    def load
      return false unless File.exists?(location)
      self.vault = Marshal.load(File.read(location))
    end

    def create
      self.vault = {}
      save
      vault
    end

    def save
      File.open(location, 'w+') { |file| file.write Marshal.dump(vault) }
    end

    def add(item)
      vault[item] = vault[item]
    end

    def include?(item)
      vault.keys.include?(item)
    end

    def relate(*items)
      items.each do |item|
        add(item) unless include?(item)
        items.each do |related_item|
          add(related_item) unless include?(related_item)
          update_relation(item, related_item) unless item == related_item
        end
      end
    end

    def relations(item)
      vault[item] || Set.new
    end

    def related?(*items)
      items.inject(true) do |related, item|
        related && items.inject(true) do |related, related_item|
          related && related_items?(item, related_item)
        end
      end
    end

    def distally_related?(item, related_item)
      !!relation_chain(item, related_item)
    end

    def relation_chain(item, related_item)
      visited = Set.new
      visited << item
      to_visit = [ [ [item] , relations(item).to_a ] ]
      loop do
        break unless to_visit.any?
        chain, items = to_visit.first
        if items.any?
          item = items.shift
          if !visited.include?(item)
            visited << item
            relations = relations(item)
            to_visit << [chain + [item], relations.to_a] if relations.any?
            return chain + [item] if item == related_item
          end
        else
          to_visit.shift
        end
      end
      false
    end

    private

      attr_accessor :vault
      attr_accessor :location

      def related_items?(item, related_item)
        case
        when item == related_item
          true
        when relations(item).include?(related_item)
          true
        else
          false
        end
      end

      def update_relation(item, related_item)
        relations = relations(item)
        relations << related_item
        vault[item] = relations if relations_empty?(item)
      end

      def relations_empty?(item)
        self.include?(item) || vault[item].nil?
      end

  end

end
