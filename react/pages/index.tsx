import { Box, Container, Heading, Text } from "@chakra-ui/react";
import type { NextPage } from "next";
import Head from "next/head";
import Image from "next/image";
import Hero from "../components/Hero";

const Home: NextPage = () => {
  return (
    <Box>
      <Head>
        <title>Home - Voting Dapp</title>
      </Head>
      <Hero />
    </Box>
  );
};

export default Home;
