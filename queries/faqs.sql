-- name: getFAQCategories :many
WITH t AS (SELECT ts.faq_categories_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title
           FROM faq_categories_translations ts
           GROUP BY ts.faq_categories_id)
SELECT c.id,
       t.title
FROM faq_categories c
         LEFT JOIN t ON c.id = t.faq_categories_id
WHERE c.status = 'published'
  AND c.id = ANY($1::int[]);

-- name: listFAQCategories :many
WITH t AS (SELECT ts.faq_categories_id,
                  json_object_agg(ts.languages_code, ts.title)    AS title
           FROM faq_categories_translations ts
           GROUP BY ts.faq_categories_id)
SELECT c.id,
       t.title
FROM faq_categories c
         LEFT JOIN t ON c.id = t.faq_categories_id
WHERE c.status = 'published';

-- name: getQuestions :many
WITH t AS (SELECT ts.faqs_id,
                  json_object_agg(ts.languages_code, ts.question) AS question,
                  json_object_agg(ts.languages_code, ts.answer)   AS answer
           FROM faqs_translations ts
           GROUP BY ts.faqs_id)
SELECT f.id,
       f.category,
       t.question,
       t.answer
FROM faqs f
    LEFT JOIN t ON f.id = t.faqs_id
    LEFT JOIN faq_categories fc on f.category = fc.id
WHERE f.status = 'published'
  AND fc.status = 'published'
  AND f.id = ANY($1::int[]);

-- name: getQuestionsForCategories :many
WITH t AS (SELECT ts.faqs_id,
                  json_object_agg(ts.languages_code, ts.question) AS question,
                  json_object_agg(ts.languages_code, ts.answer)   AS answer
           FROM faqs_translations ts
           GROUP BY ts.faqs_id)
SELECT f.id,
       f.category,
       t.question,
       t.answer
FROM faqs f
         LEFT JOIN t ON f.id = t.faqs_id
         LEFT JOIN faq_categories fc on f.category = fc.id
WHERE f.status = 'published'
  AND fc.status = 'published'
  AND f.category = ANY($1::int[]);

-- name: listQuestions :many
WITH t AS (SELECT ts.faqs_id,
                  json_object_agg(ts.languages_code, ts.question) AS question,
                  json_object_agg(ts.languages_code, ts.answer)   AS answer
           FROM faqs_translations ts
           GROUP BY ts.faqs_id)
SELECT f.id,
       f.category,
       t.question,
       t.answer
FROM faqs f
         LEFT JOIN t ON f.id = t.faqs_id
         LEFT JOIN faq_categories fc on f.category = fc.id
WHERE f.status = 'published'
  AND fc.status = 'published';

