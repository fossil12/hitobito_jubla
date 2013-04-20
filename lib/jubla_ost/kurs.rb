module JublaOst
  class Kurs < Base
    self.table_name = 'tKurs'
    self.primary_key = 'KUID'
    
    class < self
      def migrate
        find_each do |legacy|
          course = Event::Course.new
          course.groups = [Group::State.find(JublaOst::Config.kanton_id(legacy.Kanton))]
          migrate_attributes(course, legacy)
          course.save!
          cache[legacy.KUID] = course.id
          course
        end
      end
      
      private
      
      def migrate_attributes(current, legacy)
        current.name = legacy.kbez
        current.location = combine("\n", legacy.adresse, legacy.ort)
        current.maximum_participants = legacy.tnvorgesehen
        current.application_opening_at = legacy.anmeldestart
        current.application_closing_at = legacy.anmeldeschluss
        current.cost = legacy.kosten
        current.number = legacy.knr
        current.motto = legacy.motto
        current.description = legacy.bem
        current.kind_id = JublaOst::Config.event_kind_id(legacy.stufe)
        
        migrate_dates(current, legacy)
        migrate_questions(current, legacy)
      end
    
      def migrate_dates(current, legacy)
        create_date(combine(" ", 'Vorweekend', legacy.vwort),
                    legacy.vmstart,
                    legacy.vmende)
                    
        create_date('Kurs', legacy.start, legacy.ende)
      end
      
      def create_date(current, label, start, finish)
        if start.present?
          date = current.dates.build
          date.label = label
          date.start_at = start
          date.finish_at = finish
        end
      end
      
      def migrate_questions(current, legacy)
        # TODO: allen Kursen die Fragen nach ÖV Abo und Vegi hinzufügen
        # TODO: Question index und neue id im cache speichern
        (1..6).each do |i|
          q = legacy.attributes["kurs#{i}"]
          type = legacy.attributes["kurs#{i}typ"]
          if q.present?
          	question = current.questions.build
          	question.question = q
          	question.choices = 'ja,nein' if type == 1
          end
        end
      end
    	
    end
  end
end