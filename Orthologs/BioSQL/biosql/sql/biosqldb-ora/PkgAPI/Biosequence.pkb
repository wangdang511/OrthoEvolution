-- -*-Sql-*- mode (to keep my emacs happy)
--
-- API Package Body for Biosequence.
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
PACKAGE BODY Seq IS

Seq_cached	SG_BIOSEQUENCE.ENT_OID%TYPE DEFAULT NULL;
cache_key		VARCHAR2(128) DEFAULT NULL;

CURSOR Seq_c (
		Seq_OID	IN SG_BIOSEQUENCE.ENT_OID%TYPE)
RETURN SG_BIOSEQUENCE%ROWTYPE IS
	SELECT t.* FROM SG_BIOSEQUENCE t
	WHERE
		t.Ent_Oid = Seq_Oid
	;

FUNCTION get_oid(
		Seq_OID		IN SG_BIOSEQUENCE.ENT_OID%TYPE DEFAULT NULL,
		Seq_VERSION	IN SG_BIOSEQUENCE.VERSION%TYPE DEFAULT NULL,
		Seq_LENGTH	IN SG_BIOSEQUENCE.LENGTH%TYPE DEFAULT NULL,
		Seq_ALPHABET	IN SG_BIOSEQUENCE.ALPHABET%TYPE DEFAULT NULL,
		Seq_SEQ	IN SG_BIOSEQUENCE.SEQ%TYPE DEFAULT NULL,
		Ent_OID		IN SG_BIOENTRY.OID%TYPE DEFAULT NULL,
		Ent_ACCESSION	IN SG_BIOENTRY.ACCESSION%TYPE DEFAULT NULL,
		Ent_VERSION	IN SG_BIOENTRY.VERSION%TYPE DEFAULT NULL,
		Ent_IDENTIFIER	IN SG_BIOENTRY.IDENTIFIER%TYPE DEFAULT NULL,
		DB_OID		IN SG_BIOENTRY.DB_OID%TYPE DEFAULT NULL,
		DB_NAME		IN SG_BIODATABASE.NAME%TYPE DEFAULT NULL,
		DB_ACRONYM	IN SG_BIODATABASE.ACRONYM%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN SG_BIOSEQUENCE.ENT_OID%TYPE
IS
	pk	SG_BIOSEQUENCE.ENT_OID%TYPE DEFAULT NULL;
	Seq_row Seq_c%ROWTYPE;
	ENT_OID_	SG_BIOENTRY.OID%TYPE DEFAULT ENT_OID;
	key_str	VARCHAR2(128) DEFAULT Seq_OID || '|' || ENT_OID_;
BEGIN
	-- initialize
	IF (do_DML > BSStd.DML_NO) THEN
		pk := Seq_OID;
	END IF;
	-- look up
	IF (pk IS NULL) AND (key_str = cache_key) THEN
		pk := Seq_cached;
	ELSIF (pk IS NULL) THEN
		-- reset cache
		Seq_cached := NULL;
		cache_key := NULL;
		-- look up SG_BIOENTRY
		IF (ENT_OID_ IS NULL) THEN
			ENT_OID_ := Ent.get_oid(
				Ent_ACCESSION => Ent_ACCESSION,
				Ent_VERSION => Ent_VERSION,
				Ent_IDENTIFIER => Ent_IDENTIFIER,
				DB_OID => DB_OID,
				DB_NAME => DB_NAME,
				DB_ACRONYM => DB_ACRONYM);
		END IF;
		-- do the look up
		FOR Seq_row IN Seq_c (ENT_OID_) LOOP
	        	pk := Seq_row.ENT_OID;
			-- cache
			Seq_cached := pk;
			cache_key := key_str;
		END LOOP;
	END IF;
	-- insert/update if requested
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	-- look up foreign keys if not provided:
		-- look up SG_BIOENTRY successful?
		IF (ENT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ent <' || Ent_ACCESSION || '|' || Ent_VERSION || '|' || DB_OID || '|' || Ent_IDENTIFIER || '>');
		END IF;
	    	-- insert the record and obtain the primary key
		IF (Seq_SEQ IS NULL) THEN
	    		pk := do_insert(
				OID => ENT_OID_,
		        	VERSION => Seq_VERSION,
				LENGTH => Seq_LENGTH,
				ALPHABET => Seq_ALPHABET,
				SEQ => empty_clob());
		ELSE
	    		pk := do_insert(
				OID => ENT_OID_,
		        	VERSION => Seq_VERSION,
				LENGTH => Seq_LENGTH,
				ALPHABET => Seq_ALPHABET,
				SEQ => Seq_SEQ);
		END IF;
	ELSIF (do_DML = BSStd.DML_U) OR (do_DML = BSStd.DML_UI) THEN
	        -- update the record (note that not provided FKs will not
		-- be changed nor looked up)
		do_update(
			Seq_OID	=> pk,
		        Seq_VERSION => Seq_VERSION,
			Seq_LENGTH => Seq_LENGTH,
			Seq_ALPHABET => Seq_ALPHABET,
			Seq_SEQ => Seq_SEQ);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		OID	IN SG_BIOSEQUENCE.ENT_OID%TYPE,
		VERSION	IN SG_BIOSEQUENCE.VERSION%TYPE,
		LENGTH	IN SG_BIOSEQUENCE.LENGTH%TYPE,
		ALPHABET	IN SG_BIOSEQUENCE.ALPHABET%TYPE,
		SEQ	IN SG_BIOSEQUENCE.SEQ%TYPE)
RETURN SG_BIOSEQUENCE.ENT_OID%TYPE 
IS
BEGIN
	-- insert the record
	INSERT INTO SG_BIOSEQUENCE (
		ENT_OID,
		VERSION,
		LENGTH,
		ALPHABET,
		SEQ)
	VALUES (OID,
		VERSION,
		LENGTH,
		ALPHABET,
		SEQ)
	;
	-- return the new pk value
	RETURN OID;
END;

PROCEDURE do_update(
		Seq_OID		IN SG_BIOSEQUENCE.ENT_OID%TYPE,
		Seq_VERSION	IN SG_BIOSEQUENCE.VERSION%TYPE,
		Seq_LENGTH	IN SG_BIOSEQUENCE.LENGTH%TYPE,
		Seq_ALPHABET	IN SG_BIOSEQUENCE.ALPHABET%TYPE,
		Seq_SEQ	IN SG_BIOSEQUENCE.SEQ%TYPE)
IS
BEGIN
	-- update the record (and leave attributes passed as NULL untouched)
	UPDATE SG_BIOSEQUENCE
	SET
		VERSION = NVL(Seq_VERSION, VERSION),
		LENGTH = NVL(Seq_LENGTH, LENGTH),
		ALPHABET = NVL(Seq_ALPHABET, ALPHABET)
	WHERE ENT_OID = Seq_OID
	;
	-- can't do NVL on a CLOB, so need to work around it ...
	IF (Seq_Seq IS NOT NULL) THEN
		UPDATE SG_BIOSEQUENCE
		SET
			SEQ	 = Seq_Seq
		WHERE Ent_Oid = Seq_Oid
		;
	END IF;
END;

END Seq;
/

