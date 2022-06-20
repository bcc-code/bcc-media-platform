-- Program
ALTER TABLE CategoryProgram DROP
   CONSTRAINT FK_CategoryProgram_Program
GO
ALTER TABLE CategoryProgram ADD
   CONSTRAINT FK_CategoryProgram_Program
       FOREIGN KEY (ProgramId)
      REFERENCES Program (Id)
      ON DELETE CASCADE
GO

-- Series
ALTER TABLE CategorySeries DROP
   CONSTRAINT FK_CategorySeries_Series
GO
ALTER TABLE CategorySeries ADD
   CONSTRAINT FK_CategorySeries_Series
       FOREIGN KEY (SeriesId)
      REFERENCES Series (Id)
      ON DELETE CASCADE
GO

-- Series
ALTER TABLE CategorySeries DROP
   CONSTRAINT FK_CategoryEpisode_Episode
GO
ALTER TABLE CategoryEpisode ADD
   CONSTRAINT FK_CategoryEpisode_Episode
       FOREIGN KEY (EpisodeId)
      REFERENCES Episode (Id)
      ON DELETE CASCADE
GO

-- Category
ALTER TABLE CategoryProgram DROP
   CONSTRAINT FK_CategoryProgram_Category
GO
ALTER TABLE CategoryProgram ADD
   CONSTRAINT FK_CategoryProgram_Category
       FOREIGN KEY (CategoryId)
      REFERENCES Category (Id)
      ON DELETE CASCADE
GO

ALTER TABLE CategoryEpisode DROP
   CONSTRAINT FK_CategoryEpisode_Category
GO
ALTER TABLE CategoryEpisode ADD
   CONSTRAINT FK_CategoryEpisode_Category
       FOREIGN KEY (CategoryId)
      REFERENCES Category (Id)
      ON DELETE CASCADE
GO

ALTER TABLE CategorySeries DROP
   CONSTRAINT FK_CategorySeries_Category
GO
ALTER TABLE CategorySeries ADD
   CONSTRAINT FK_CategorySeries_Category
       FOREIGN KEY (CategoryId)
      REFERENCES Category (Id)
      ON DELETE CASCADE
GO
