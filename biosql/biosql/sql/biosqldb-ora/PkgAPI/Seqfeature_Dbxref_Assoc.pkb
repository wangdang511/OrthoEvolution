-- -*-Sql-*- mode (to keep my emacs happy)
--
-- API Package Body for Seqfeature_Dbxref_Assoc.
--
-- Scaffold auto-generated by gen-api.pl. gen-api.pl is
-- Copyright 2002-2003 Genomics Institute of the Novartis Research Foundation
-- Copyright 2002-2008 Hilmar Lapp
-- 
--  This file is part of BioSQL.
--
--  BioSQL is free software: you can redistribute it and/or modify it
--  under the terms of the GNU Lesser General Public License as
--  published by the Free Software Foundation, either version 3 of the
--  License, or (at your option) any later version.
--
--  BioSQL is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with BioSQL. If not, see <http://www.gnu.org/licenses/>.
--

CREATE OR REPLACE
PACKAGE BODY DbxFeaA IS

CURSOR DbxFeaA_c (
		DbxFeaA_FEA_OID	IN SG_SEQFEATURE_DBXREF_ASSOC.FEA_OID%TYPE,
		DbxFeaA_DBX_OID	IN SG_SEQFEATURE_DBXREF_ASSOC.DBX_OID%TYPE)
RETURN SG_SEQFEATURE_DBXREF_ASSOC%ROWTYPE IS
	SELECT t.* FROM SG_SEQFEATURE_DBXREF_ASSOC t
	WHERE
		FEA_OID = DbxFeaA_FEA_OID
	AND	DBX_OID = DbxFeaA_DBX_OID
	;

FUNCTION get_oid(
		FEA_OID	IN SG_SEQFEATURE_DBXREF_ASSOC.FEA_OID%TYPE DEFAULT NULL,
		DBX_OID	IN SG_SEQFEATURE_DBXREF_ASSOC.DBX_OID%TYPE DEFAULT NULL,
		DbxFeaA_RANK	IN SG_SEQFEATURE_DBXREF_ASSOC.RANK%TYPE DEFAULT NULL,
		Fea_ENT_OID	IN SG_SEQFEATURE.ENT_OID%TYPE DEFAULT NULL,
		Fea_TYPE_TRM_OID	IN SG_SEQFEATURE.TYPE_TRM_OID%TYPE DEFAULT NULL,
		Fea_SOURCE_TRM_OID	IN SG_SEQFEATURE.SOURCE_TRM_OID%TYPE DEFAULT NULL,
		Fea_RANK	IN SG_SEQFEATURE.RANK%TYPE DEFAULT NULL,
		Dbx_ACCESSION	IN SG_DBXREF.ACCESSION%TYPE DEFAULT NULL,
		Dbx_DBNAME	IN SG_DBXREF.DBNAME%TYPE DEFAULT NULL,
		Dbx_VERSION	IN SG_DBXREF.VERSION%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN INTEGER
IS
	pk	INTEGER DEFAULT NULL;
	DbxFeaA_row DbxFeaA_c%ROWTYPE;
	FEA_OID_	SG_SEQFEATURE.OID%TYPE DEFAULT FEA_OID;
	DBX_OID_	SG_DBXREF.OID%TYPE DEFAULT DBX_OID;
BEGIN
	-- initialize
	-- look up SG_SEQFEATURE
	IF (FEA_OID_ IS NULL) THEN
		FEA_OID_ := Fea.get_oid(
				ENT_OID => Fea_ENT_OID,
				TYPE_TRM_OID => Fea_TYPE_TRM_OID,
				SOURCE_TRM_OID => Fea_SOURCE_TRM_OID,
				Fea_RANK => Fea_RANK);
	END IF;
	-- look up SG_DBXREF
	IF (DBX_OID_ IS NULL) THEN
		DBX_OID_ := Dbx.get_oid(
				Dbx_ACCESSION => Dbx_ACCESSION,
				Dbx_DBNAME => Dbx_DBNAME,
				Dbx_VERSION => Dbx_VERSION);
	END IF;
	-- do the look up
	FOR DbxFeaA_row IN DbxFeaA_c (FEA_OID_, DBX_OID_) LOOP
        	pk := 1;
	END LOOP;
	-- insert/update if requested
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	-- look up foreign keys if not provided:
		-- look up SG_SEQFEATURE successful?
		IF (FEA_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Fea <' || Fea_ENT_OID || '|' || Fea_TYPE_TRM_OID || '|' || Fea_SOURCE_TRM_OID || '|' || Fea_RANK || '>');
		END IF;
		-- look up SG_DBXREF successful?
		IF (DBX_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Dbx <' || Dbx_ACCESSION || '|' || Dbx_DBNAME || '|' || Dbx_VERSION || '>');
		END IF;
	    	-- insert the record and obtain the primary key
	    	pk := do_insert(
			FEA_OID => FEA_OID_,
		        DBX_OID => DBX_OID_,
			RANK => DbxFeaA_RANK);
	ELSIF (do_DML = BSStd.DML_U) OR (do_DML = BSStd.DML_UI) THEN
	        -- update the record (note that not provided FKs will not
		-- be changed nor looked up)
		do_update(
			DbxFeaA_FEA_OID	=> FEA_OID_,
		        DbxFeaA_DBX_OID => DBX_OID_,
			DbxFeaA_RANK => DbxFeaA_RANK);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		FEA_OID	IN SG_SEQFEATURE_DBXREF_ASSOC.FEA_OID%TYPE,
		DBX_OID	IN SG_SEQFEATURE_DBXREF_ASSOC.DBX_OID%TYPE,
		RANK	IN SG_SEQFEATURE_DBXREF_ASSOC.RANK%TYPE)
RETURN INTEGER
IS
BEGIN
	-- insert the record
	INSERT INTO SG_SEQFEATURE_DBXREF_ASSOC (
		FEA_OID,
		DBX_OID,
		RANK)
	VALUES (FEA_OID,
		DBX_OID,
		RANK)
	;
	-- return TRUE
	RETURN 1;
END;

PROCEDURE do_update(
		DbxFeaA_FEA_OID	IN SG_SEQFEATURE_DBXREF_ASSOC.FEA_OID%TYPE,
		DbxFeaA_DBX_OID	IN SG_SEQFEATURE_DBXREF_ASSOC.DBX_OID%TYPE,
		DbxFeaA_RANK	IN SG_SEQFEATURE_DBXREF_ASSOC.RANK%TYPE)
IS
BEGIN
	-- update the record (and leave attributes passed as NULL untouched)
	UPDATE SG_SEQFEATURE_DBXREF_ASSOC
	SET
		RANK = NVL(DbxFeaA_RANK, RANK)
	WHERE FEA_OID = DbxFeaA_FEA_OID
	AND   DBX_OID = DbxFeaA_DBX_OID
	;
END;

END DbxFeaA;
/

