# Lab 09: Knowledge check

**Answer each question below it, in your own words, in one to three sentences.** Replace the `...` below **Your answer:** with your text.

## 1. Credentials in the image?

Assume you want to share your image with others and make it publicly available on `ghcr.io`, so that anyone can pull it and run the analysis. A teammate suggests adding `COPY .aws /home/app/.aws` to the `Dockerfile`, so that nobody has to type `-v ~/.aws:/home/app/.aws:ro` any more. (This is a thought experiment: keep your own package private.)

**Your answer:** Give two reasons why this is a bad idea. Think of who could then read your credentials, and of what happens when your Learner Lab session ends.

If the image is public, anyone who acesses it can read all the files including my aws keys, which would allow them to use my aws account. Also, the credentials expire when the lab session ends, so the copied keys would stop working and I would have to redo it with new ones.

## 2. Where did the Atlas password come from?

In Step 4, you ran the analysis once with `-v ~/.aws:/home/app/.aws:ro` only, without the three `-e` options. The container still wrote to your Atlas cluster.

*Hint:* Read `get_atlas_settings()` in `src/book_analysis/analyze.py`.

**Your answer:** Explain, step by step, where the container found the Atlas settings in that run.

Without the -e options the mongodb variables are not set inside the container, so the get_atlas_settings command would go back to reading mongodb_credentials. The aws directory gave boto3 my aws credentials. The parameter that was created in lab 7 holds the atlas url,username, and password, so the container was able to write to my cluster.

## 3. Same tag, different image

Run `docker images book-analysis`, and note the image ID of `book-analysis:0.1.0`. Then change the `description` in the `LABEL` of your `Dockerfile`, build again with the same command, `docker build -t book-analysis:0.1.0 .`, and run `docker images book-analysis` again.

**Your answer:** Paste the image ID from before and after the rebuild. Why is it a problem for someone who uses your image that `0.1.0` now names a different image, and what should you have done instead?

Before: cec8aaf8db63 After: 23d44c3738ac. Anyone who already pulled 0.1.0 would expect one exact image. However now, the same tag would lead to different contents so the user would get different results without realizing. I should have changed the version and built it under a new tag like 0.1.1 and left 0.1.0 unchanged.
