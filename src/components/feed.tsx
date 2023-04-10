import { Moment, ThemeToggle } from "@components";
import { AnimatePresence, motion } from "framer-motion";
import { useEffect, useState } from "react";
import { useRecoilState } from "recoil";

import { useMomentSwapContract, useSpaceFNSContract } from "@hooks";
import { MomentMetadata } from "@utils/definitions/interfaces";
import { collectionToMoments } from "@utils/helpers/collection-to-moments";
import { searchKeyState } from "src/atom";

export const Feed = () => {
  const [moments, setMoments] = useState<Array<MomentMetadata>>([]);
  const { getNFTCollection } = useMomentSwapContract();
  const [searchKey, setSearchKey] = useRecoilState(searchKeyState);
  const { getAllDomainByCreator, getAvatar } = useSpaceFNSContract();
  useEffect(() => {
    (async () => {
      const collection = await getNFTCollection();

      const _moments = await collectionToMoments(collection);
      for (let m of _moments) {
        try {
          const [_mainDomain] = await getAllDomainByCreator(m.address);
          m.username = _mainDomain;

          const _avatarUrl = await getAvatar(m.address);
          m.userImg = _avatarUrl;
        } catch {
          m.username = "---";
        }
      }
      setMoments(_moments);
    })();
  }, [getNFTCollection, getAvatar]);

  return (
    <div className="border-l border-r border-primary xl:min-w-[576px] flex-grow max-w-xl w-[100vw]">
      <div className="flex items-center justify-between p-2 sticky top-0 z-50 bg-base-200 border-primary">
        <h2 className="text-lg sm:text-xl font-bold cursor-pointer">Home</h2>
        <img src="/logo.png" alt="" className="h-8 w-8 sm:hidden" />
        <div className="flex items-center justify-center px-0 w-9 h-9">
          <ThemeToggle />
        </div>
      </div>
      <AnimatePresence>
        {moments.map((moment) => (
          <motion.div
            key={moment.id}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 1 }}
          >
            <Moment key={moment.id} moment={moment} />
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );
};
