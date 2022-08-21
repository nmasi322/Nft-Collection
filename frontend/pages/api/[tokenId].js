export default function handler(req, res) {
  // get the tokenId from the query params
  const tokenId = req.query.tokenId;
  // As all the images are uploaded on github, we can extract the images from github directly.
  const image_url =
    "https://raw.githubusercontent.com/nmasi322/Nft-Collection/master/frontend/public/cryptodevs/";
  res.status(200).json({
    name: "JS Dev #" + tokenId,
    description: "JS Dev is a collection of Javascript developers in crypto",
    image: image_url + tokenId + ".svg",
  });
}