-- name: getFAQCategories :many
WITH t AS (SELECT ts.faqcategories_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM faqcategories_translations ts
           WHERE ts.faqcategories_id = ANY (@ids::uuid[])
           GROUP BY ts.faqcategories_id)
SELECT c.id,
       c.title       as original_title,
       c.description as original_description,
       t.title,
       t.description
FROM faqcategories c
         LEFT JOIN t ON c.id = t.faqcategories_id
WHERE c.status = 'published'
  AND c.id = ANY (@ids::uuid[]);

-- name: listFAQCategories :many
WITH t AS (SELECT ts.faqcategories_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM faqcategories_translations ts
           GROUP BY ts.faqcategories_id)
SELECT c.id,
       c.title       as original_title,
       c.description as original_description,
       t.title,
       t.description
FROM faqcategories c
         LEFT JOIN t ON c.id = t.faqcategories_id
WHERE c.status = 'published';

-- name: getQuestions :many
WITH t AS (SELECT ts.faqs_id,
                  json_object_agg(ts.languages_code, ts.question) AS question,
                  json_object_agg(ts.languages_code, ts.answer)   AS answer
           FROM faqs_translations ts
           WHERE ts.faqs_id = ANY (@ids::uuid[])
           GROUP BY ts.faqs_id)
SELECT f.id,
       f.category_id,
       f.question as original_question,
       f.answer   as original_answer,
       t.question,
       t.answer
FROM faqs f
         LEFT JOIN t ON f.id = t.faqs_id
         LEFT JOIN faqcategories fc on f.category_id = fc.id
WHERE f.status = 'published'
  AND fc.status = 'published'
  AND f.id = ANY (@ids::uuid[]);

-- name: getQuestionIDsForCategories :many
SELECT f.id, f.category_id
FROM faqs f
         LEFT JOIN faqcategories fc on f.category_id = fc.id
WHERE f.status = 'published'
  AND fc.status = 'published'
  AND f.category_id = ANY ($1::uuid[]);
