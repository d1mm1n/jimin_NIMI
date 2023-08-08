from django.db import models

class Test(models.Model):
    name = models.CharField(max_length=50)
    age = models.IntegerField()

    def __str__(self):
        return self.name
    
    class Meta:
        db_table = 'Test'
