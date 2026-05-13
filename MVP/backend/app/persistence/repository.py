from app.extensions import db
from abc import ABC, abstractmethod

class Repository(ABC):
    @abstractmethod
    def add(self, obj):
        pass

    @abstractmethod
    def get(self, obj_id):
        pass

    @abstractmethod
    def get_all(self):
        pass

    @abstractmethod
    def update(self, obj_id, data):
        pass

    @abstractmethod
    def delete(self, obj_id):
        pass

    @abstractmethod
    def soft_delete(self, obj_id):
        pass

    @abstractmethod
    def get_by_attribute(self, attr_name, attr_value):
        pass

    @abstractmethod
    def get_all_by_attribute(self, attr_name, attr_value):
        pass

class SQLAlchemyRepository(Repository):
    def __init__(self, model):
        self.model = model

    def add(self, obj):
        """ add object to database"""
        try:
            db.session.add(obj)
            db.session.commit()
            return obj
        except Exception as e:
            db.session.rollback()
            raise e

    def get(self, obj_id):
        """
        Fetch an object by ID, ignoring soft-deleted records.
        """
        obj = self.model.query.get(obj_id)

        # returns None if the record is logically deleted to prevent data leakage.
        if obj and hasattr(obj, 'deleted_at') and obj.deleted_at is not None:
            return None
        return obj 

    def get_all(self):
        """
        Fetch all records, excluding soft-deleted ones.
        """

        # Dynamically filters out soft-deleted records if the model supports logical deletion.
        if hasattr(self.model, 'deleted_at'):
            return self.model.query.filter(self.model.deleted_at.is_(None)).all()
        return self.model.query.all()

    def update(self, obj_id, data):
        """Update object with new data."""
        
        obj = self.get(obj_id)
        if not obj:
            return None
        try:
            for key, value in data.items():
                setattr(obj, key, value)
            db.session.commit()
            return obj
        except Exception as e:
            db.session.rollback()
            raise e
        
    def delete(self, obj_id):
        """Hard delete an object from the database."""
        obj = self.get(obj_id)
        if not obj:
            return False
        try:
            db.session.delete(obj)
            db.session.commit()
            return True
        except Exception as e:
            db.session.rollback()
            raise e

    def soft_delete(self, obj_id):
        """Marks a record as deleted without removing it from the DB."""
        from datetime import datetime, timezone
        obj = self.get(obj_id)

        # if the table has "deleted_at" column
        if obj and hasattr(obj, 'deleted_at'): 
            try:
                obj.deleted_at = datetime.now(timezone.utc) 

                # Check if the model also has an is_active column before modifying it
                if hasattr(obj, 'is_active'):
                    obj.is_active = False
                    
                db.session.commit()
                return True
            except Exception as e:
                db.session.rollback()
                raise e
        return False

    def get_by_attribute(self, attr_name, attr_value):
        """
        Dynamically filters the model by a specified attribute and value. 
        Automatically applies a soft-delete constraint if supported, 
        returning only the first active record.
        """
        query = self.model.query.filter(getattr(self.model, attr_name) == attr_value)
        if hasattr(self.model, 'deleted_at'):
            query = query.filter(self.model.deleted_at.is_(None))
        return query.first()
    
    def get_all_by_attribute(self, attr_name, attr_value):
        """
        Returns a list of all matching objects, excluding soft-deleted ones.
        """
        query = self.model.query.filter(getattr(self.model, attr_name) == attr_value)
        if hasattr(self.model, 'deleted_at'):
            query = query.filter(self.model.deleted_at.is_(None))
        return query.all()